data "aws_iam_policy" "ssm_managed_instance_core" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ssm" {
    source_policy_documents = [data.aws_iam_policy.ssm_managed_instance_core.policy]

    # TODO: var.target_ecr_arn など入力変数を使ってターゲットリソースを絞り込むこと
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "kms:Decrypt",
        ]
        resources = [
            "*"
        ]
    }
}
