module "cloudwatch_start_ecs_role" {
    source = "../../iam-role"
    name = "${var.prefix}-cloudwatch-start-ecs"
    identifiers = ["events.amazonaws.com"]
    policy_document = data.aws_iam_policy.cloudwatch_start_ecs_role_policy.policy
}
