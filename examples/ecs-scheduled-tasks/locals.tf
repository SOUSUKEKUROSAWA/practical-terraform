locals {
    batch_id = "1111"
    log_group_name = "/ecs-scheduled-tasks/${local.batch_id}"
    vpc_cidr_blocks = "10.0.0.0/16"
}

data "aws_region" "current" {}
