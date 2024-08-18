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

module "ssm_role" {
    source = "../iam-role"
    name = "${var.name}-ssm"
    identifiers = ["ec2.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.ssm.json
}

# EC2では直接IAMロールを関連付けする代わりにインスタンスプロファイルを使う
resource "aws_iam_instance_profile" "this" {
    name = "${var.name}"
    role = "${var.name}-ssm"
}

resource "aws_instance" "this" {
    ami = var.ami
    instance_type = var.instance_type
    iam_instance_profile = aws_iam_instance_profile.this.name
    subnet_id = var.subnet_id
    user_data = file("${path.module}/user_data.sh")
}

# TODO: 可能であればモジュールを利用する形に変更する
resource "aws_s3_bucket" "log" {
    bucket = "${var.name}-log"
}

resource "aws_s3_bucket_lifecycle_configuration" "rotation" {
    bucket = aws_s3_bucket.log.id
    rule {
        id = "rotation"
        expiration {
            days = var.log_retention_in_days
        }
        status = "Enabled"
    }
}

resource "aws_cloudwatch_log_group" "operation" {
    name = "/operation"
    retention_in_days = 180
}

resource "aws_ssm_document" "session_manager_run_shell" {
    name = "SSM-SessionManagerRunShell" # この名前にしておくとAWS CLIを使用する際のオプション指定を省略できる
    document_type = "Session"
    document_format = "JSON"
    content = jsonencode({
        schemaVersion = "1.0"
        description = "Document to hold regional settings for Session Manager"
        sessionType = "Standard_Stream"
        inputs = {
            s3BucketName = aws_s3_bucket.log.id
            cloudWatchLogGroupName = aws_cloudwatch_log_group.operation.name
        }
    })
}
