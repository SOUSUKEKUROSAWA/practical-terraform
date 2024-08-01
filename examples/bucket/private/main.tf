module "example" {
    source = "../../../modules/bucket/private"
    name = "practical-terraform-example-private"
    enable_log_rotation = true
    log_expiration_days = 180
    policy_document = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
        ]
        resources = [
            "${module.example.bucket_arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = [
                data.aws_caller_identity.self.arn,
            ]
        }
    }
}
