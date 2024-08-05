module "ecs_task_execution_role" {
    source = "../../iam-role"
    name = "${var.prefix}-ecs-task-execution"
    identifiers = ["ecs-tasks.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.ecs_task_execution.json
}

# ベースのポリシードキュメントを拡張
data "aws_iam_policy_document" "ecs_task_execution" {
    # 既存のポリシーを継承
    source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

    # SSMパラメートストアとの統合
    statement {
        effect = "Allow"
        actions = ["ssm:GetParameters", "kms:Decrypt"]
        resources = ["*"]
    }
}
