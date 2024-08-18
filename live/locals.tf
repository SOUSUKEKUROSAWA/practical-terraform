locals {
    project_name = "practical-terraform"
    az_1 = "us-east-2a"
    az_2 = "us-east-2b"
    vpc_cidr_block = "10.0.0.0/16"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
    http_default_port = 80
    nginx_container_name = "nginx"
    nginx_container_image = "nginx:latest"
    nginx_container_awslogs_stream_prefix = "nginx"
    ecs_log_group_name = "/ecs/${local.project_name}"
    platform_version = "1.4.0"
    batch_id = "1111"
    batch_log_group_name = "/ecs-scheduled-tasks/${local.batch_id}"
    db_engine_name = "mysql"
    db_engine_version = "5.7"
    db_engine_port = 3306
    db_character_set = "utf8mb4"
    db_master_username = "Admin"
    cache_engine = "redis"
    cache_engine_version = "5.0"
    cache_engine_version_with_minor = "5.0.6"
    cache_engine_port = 6379

    # リソース作成切り替え
    create_batch = true
    create_db = false
    create_redis = false
    create_pipeline = false
}

data "aws_region" "current" {}
