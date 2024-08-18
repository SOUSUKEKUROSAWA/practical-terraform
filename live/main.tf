# リソースが属するネットワーク
module "vpc" {
    source = "../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_block
    name = local.project_name
    public_subnet_cidr_blocks = local.public_subnet_cidr_blocks
    private_subnet_cidr_blocks = local.private_subnet_cidr_blocks
    availability_zones = local.availability_zones
}

# インターネットからトラフィックを受け取りECSの各コンテナに振り分ける
module "alb" {
    source = "../modules/alb"
    name = local.project_name
    security_group_ids = [module.alb_sg.security_group_id]
    public_subnet_ids = module.vpc.public_subnet_ids
}

# ビジネス処理を行うアプリケーション
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
            # WARN: setup/*を先にApplyしないとエラーになる
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

# アプリケーションとは非同期に大量データを一括処理するバッチ
# アプリケーションのECSクラスタに依存している
module "batch" {
    count = local.create_batch ? 1 : 0

    source = "../modules/ecs-scheduled-tasks"
    batch_id = local.batch_id
    batch_name = "現在時刻出力バッチ"
    batch_schedule_expression = "cron(*/2 * * * ? *)" # 2分おきに実行
    batch_description = "2分おきに現在時刻を出力する"
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    cloudwatch_start_ecs_role_arn = module.cloudwatch_start_ecs_role[0].arn
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


# アプリケーションデータの永続化
module "db" {
    count = local.create_db ? 1 : 0

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
    kms_key_arn = module.kms_key[0].arn
    master_username = local.db_master_username
    enable_multi_az = true
    backup_window_utc = "09:10-09:40"
    maintenance_window_utc = "mon:10:10-mon:10:40"
    option_group_name = aws_db_option_group.mariadb_audit_plugin[0].name
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
    private_subnet_ids = module.vpc.private_subnet_ids

    # インスタンスを削除する際に追加するパラメータ
    # deletion_protection = false
    # skip_final_snapshot = true
}

# アプリケーションキャッシュの一時的な保存
module "redis" {
    count = local.create_redis ? 1 : 0

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

# ECS へのデプロイメントパイプライン
module "pipeline" {
    count = local.create_pipeline ? 1 : 0

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
