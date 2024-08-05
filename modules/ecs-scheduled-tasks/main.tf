resource "aws_ecs_task_definition" "this" {
    family = var.batch_id
    cpu = var.cpu
    memory = var.memory
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions = var.container_definitions
    execution_role_arn = var.ecs_task_execution_role_arn
}

resource "aws_cloudwatch_event_rule" "this" {
    name = var.batch_id
    schedule_expression = var.batch_schedule_expression
    description = "${var.batch_name}: ${var.batch_description}"
}

resource "aws_cloudwatch_event_target" "this" {
    target_id = var.batch_id
    rule = aws_cloudwatch_event_rule.this.name
    role_arn = var.cloudwatch_start_ecs_role_arn
    arn = var.ecs_cluster_arn

    ecs_target {
        launch_type = "FARGATE"
        task_count = 1
        platform_version = var.platform_version
        task_definition_arn = aws_ecs_task_definition.this.arn

        network_configuration {
            assign_public_ip = var.assign_public_ip
            subnets = var.subnet_ids
        }
    }
}

# バッチごとにロググループを作成
resource "aws_cloudwatch_log_group" "this" {
    name = var.log_group_name
    retention_in_days = var.log_retention_in_days
}
