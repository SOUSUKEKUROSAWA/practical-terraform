locals {
    batch_id = "1111"
    log_group_name = "/ecs-scheduled-tasks/${local.batch_id}"
    vpc_cidr_blocks = "10.0.0.0/16"
    db_username = "/db/username"
    db_password = "/db/password"
}

data "aws_region" "current" {}
