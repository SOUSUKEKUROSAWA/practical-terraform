resource "aws_ecs_cluster" "this" {
    name = var.name
}

resource "aws_ecs_task_definition" "this" {
    family = var.name
    cpu = var.cpu
    memory = var.memory
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions = var.container_definitions
    execution_role_arn = var.ecs_task_execution_role_arn
    task_role_arn = var.enable_execute_command ? module.execute_command_role[0].arn : null
}

resource "aws_ecs_service" "this" {
    name = var.name
    cluster = aws_ecs_cluster.this.arn
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = var.desired_count
    launch_type = "FARGATE"
    platform_version = var.platform_version
    health_check_grace_period_seconds = var.health_check_grace_period_seconds
    enable_execute_command = var.enable_execute_command

    network_configuration {
        assign_public_ip = var.assign_public_ip
        security_groups = var.security_group_ids
        subnets = var.subnet_ids
    }

    load_balancer {
        target_group_arn = var.target_group_arn
        container_name = var.container_name
        container_port = var.container_port
    }

    # デプロイのたびに更新されるタスク定義は，リソースの初回作成時以降Terraform上では変更を無視する
    lifecycle {
        ignore_changes = [task_definition] 
    }
}

resource "aws_cloudwatch_log_group" "for_ecs" {
    name = var.log_group_name
    retention_in_days = var.log_retention_in_days
}

module "execute_command_role" {
    count = var.enable_execute_command ? 1 : 0
    source = "../iam-role"
    name = "${var.name}-execute-command"
    identifiers = ["ecs-tasks.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.execute_command[0].json
}

data "aws_iam_policy_document" "execute_command" {
    count = var.enable_execute_command ? 1 : 0
    statement {
        effect = "Allow"
        actions = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
        ]
        resources = [
            "*"
        ]
    }
}
