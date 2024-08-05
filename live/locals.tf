locals {
    project_name = "practical-terraform"
    az_1 = "us-east-2a"
    az_2 = "us-east-2b"
    vpc_cidr = "10.0.0.0/16"
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
}

data "aws_region" "current" {}
