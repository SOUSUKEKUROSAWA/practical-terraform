locals {
    nginx_container_name = "example"
    nginx_container_port = 80
    log_group_name = "/ecs/example"
    vpc_cidr_blocks = "10.0.0.0/16"
}

data "aws_region" "current" {}
