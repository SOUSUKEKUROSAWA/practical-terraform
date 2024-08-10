module "vpc" {
    source = "../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_block
    name = local.project_name
    public_subnet_cidr_blocks = local.public_subnet_cidr_blocks
    private_subnet_cidr_blocks = local.private_subnet_cidr_blocks
    availability_zones = local.availability_zones
}

module "alb_sg" {
    source = "../modules/network/secutiry-group"
    name = "${local.project_name}-alb"
    vpc_id = module.vpc.vpc_id
    port = local.http_default_port
    cidr_blocks = ["0.0.0.0/0"]
}

module "alb" {
    source = "../modules/alb"
    name = local.project_name
    security_group_ids = [module.alb_sg.security_group_id]
    public_subnet_ids = module.vpc.public_subnet_ids
}

module "listener_rule" {
    source = "../modules/alb/listener-rule"
    listener_arn = module.alb.listener_arn
    listener_rule_priority_rank = 100
    listener_rule_path_patterns = ["*"]
    target_group_name = local.project_name
    target_type = "ip"
    target_vpc_id = module.vpc.vpc_id

    # WARN: ALBが先に必要
    depends_on = [module.alb]
}

# ターゲットグループが先に作成されていないとApplyできないので新規作成時はコメントアウト
# module "additional_listener_rule" {
#     source = "../modules/alb/listener-rule"
#     listener_arn = module.alb.listener_arn
#     listener_rule_priority_rank = 90
#     listener_rule_path_patterns = ["/aaa"]
#     target_group_arn = <既存のターゲットグループのARN>

#     # WARN: ALBが先に必要
#     depends_on = [module.alb]
# }

module "ecs_nginx_sg" {
    source = "../modules/network/secutiry-group"
    name = "${local.project_name}-ecs-nginx"
    vpc_id = module.vpc.vpc_id
    port = local.http_default_port
    cidr_blocks = [local.vpc_cidr_block]
}

module "ecs" {
    source = "../modules/ecs-fargate"
    name = local.project_name
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    desired_count = 2
    platform_version = local.platform_version
    security_group_ids = [module.ecs_nginx_sg.security_group_id]
    subnet_ids = module.vpc.private_subnet_ids
    target_group_arn = module.listener_rule.target_group_arn
    container_name = local.nginx_container_name
    container_port = local.http_default_port
    log_group_name = local.ecs_log_group_name

    container_definitions = jsonencode([
        {
            name = local.nginx_container_name
            image = local.nginx_container_image
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = data.aws_region.current.name
                    awslogs-stream-prefix = local.nginx_container_awslogs_stream_prefix
                    awslogs-group = local.ecs_log_group_name
                }
            }
            secrets = [
                # name: コンテナ内での環境変数名
                # valueFrom: SSMパラメートストアのパラメータ名
                {
                    name = "DB_USERNAME",
                    valueFrom = "/db/username"
                },
                {
                    name = "DB_PASSWORD",
                    valueFrom = "/db/password"
                }
            ]
            portMappings = [
                {
                    protocol = "tcp"
                    containerPort = local.http_default_port
                }
            ]
        }
    ])
}

module "batch" {
    source = "../modules/ecs-scheduled-tasks"
    batch_id = local.batch_id
    batch_name = "現在時刻出力バッチ"
    batch_schedule_expression = "cron(*/2 * * * ? *)" # 2分おきに実行
    batch_description = "2分おきに現在時刻を出力する"
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    cloudwatch_start_ecs_role_arn = module.cloudwatch_start_ecs_role.arn
    ecs_cluster_arn = module.ecs.cluster_arn
    platform_version = local.platform_version
    subnet_ids = [module.vpc.private_subnet_ids[0]]
    log_group_name = local.batch_log_group_name

    container_definitions = jsonencode([
        {
            name = "alpine"
            image = "alpine:latest"
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = data.aws_region.current.name
                    awslogs-stream-prefix = "batch-${local.batch_id}"
                    awslogs-group = local.batch_log_group_name
                }
            },
            command = [
                "/bin/date", # 日付を出力するコマンド
            ]
        }
    ])
}

module "ecs_task_execution_role" {
    source = "../modules/iam-role/ecs-task-execution"
    prefix = local.project_name
}

module "cloudwatch_start_ecs_role" {
    source = "../modules/iam-role/cloudwatch_start_ecs"
    prefix = local.project_name
}

module "db" {
    source = "../modules/rds"
    name = local.project_name
    engine = local.db_engine_name
    engine_version = local.db_engine_version
    port = local.db_engine_port
    parameters = {
        character_set_database = local.db_character_set
        character_set_server = local.db_character_set
    }
    instance_class = "db.t3.small"
    allocated_storage = 20
    max_allocated_storage = 100
    storage_type = "gp2"
    kms_key_arn = module.kms_key.arn
    master_username = local.db_master_username
    enable_multi_az = true
    backup_window_utc = "09:10-09:40"
    maintenance_window_utc = "mon:10:10-mon:10:40"
    option_group_name = aws_db_option_group.mariadb_audit_plugin.name
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
    private_subnet_ids = module.vpc.private_subnet_ids

    # インスタンスを削除する際に追加するパラメータ
    # deletion_protection = false
    # skip_final_snapshot = true
}

resource "aws_db_option_group" "mariadb_audit_plugin" {
    name = local.project_name
    engine_name = local.db_engine_name
    major_engine_version = local.db_engine_version

    option {
        option_name = "MARIADB_AUDIT_PLUGIN"
    }
}

module "redis" {
    source = "../modules/cache"
    name = local.project_name
    description = "Cluster Disabled"
    engine = local.cache_engine
    engine_version = local.cache_engine_version
    engine_version_with_minor = local.cache_engine_version_with_minor
    port = local.cache_engine_port
    parameters = {
        cluster-enabled = "no"
    }
    private_subnet_ids = module.vpc.private_subnet_ids
    num_cache_clusters = 3
    instance_class = "cache.m5.large"
    snapshot_window_utc = "09:10-10:10"
    maintenance_window_utc = "mon:10:40-mon:11:40"
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
}

module "kms_key" {
    source = "../modules/master-key"
    name = local.project_name
    description = "For DB Disk Encryption"
    is_enabled = true
    deletion_window_in_days = 7
}

module "pipeline" {
  source = "../modules/pipeline"

  name = local.project_name # S3バケットの命名は全世界で一意である必要があるため
  codebuild_role_policy_document = data.aws_iam_policy_document.codebuild.json
  codepipeline_role_policy_document = data.aws_iam_policy_document.codepipeline.json
  enable_privileged_mode = true # dockerコマンド実行のため
  github_owner_name = "SOUSUKEKUROSAWA"
  github_target_repository_name = local.project_name
  github_target_branch_name = "main"
  ecs_target_cluster_name = local.project_name
  ecs_target_service_name = local.project_name
}

data "aws_iam_policy_document" "codebuild" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImage",
            "ecr:BatchGetImage",
            "ecr:InitialLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
        ]
        resources = [
            "*"
        ]
    }
}

data "aws_iam_policy_document" "codepipeline" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "ecs:DescribeServices",
            "ecs:DescribeTasks",
            "ecs:ListTasks",
            "ecs:RegisterTaskDefinition",
            "ecs:UpdateService",
            "iam:PassRole",
        ]
        resources = [
            "*"
        ]
    }
}
