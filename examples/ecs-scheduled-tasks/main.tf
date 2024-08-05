module "example" {
    source = "../../modules/ecs-scheduled-tasks"
    batch_id = local.batch_id
    batch_name = "現在時刻出力バッチ"
    batch_schedule_expression = "cron(*/2 * * * ? *)" # 2分おきに実行
    batch_description = "2分おきに現在時刻を出力する"
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    cloudwatch_start_ecs_role_arn = module.cloudwatch_start_ecs_role.arn
    ecs_cluster_arn = aws_ecs_cluster.batch.arn
    platform_version = "1.4.0"
    subnet_ids = [module.vpc.private_subnet_ids[0]]
    log_group_name = local.log_group_name

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
                    awslogs-group = local.log_group_name
                }
            },
            command = [
                "/bin/date", # 日付を出力するコマンド
            ]
        }
    ])
}

resource "aws_ecs_cluster" "batch" {
    name = "example"
}

# この検証ではDockerHubからイメージをプルできる
# （= NATゲートウェイ経由でインターネットに接続できる）
# プライベートサブネットが 1 つあれば十分
module "vpc" {
    source = "../../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_blocks
    name = "example"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
}

module "ecs_task_execution_role" {
    source = "../../modules/iam-role/ecs-task-execution"
    prefix = "example"
}

module "cloudwatch_start_ecs_role" {
    source = "../../modules/iam-role/cloudwatch_start_ecs"
    prefix = "example"
}
