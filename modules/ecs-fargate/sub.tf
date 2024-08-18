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
