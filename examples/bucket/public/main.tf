module "example" {
    source = "../../../modules/bucket/public"
    name = "practical-terraform-example-public"
    cors_allowed_headers = ["*"]
    cors_allowed_methods = ["GET"]
    cors_allowed_origins = ["http://example.com"]
    cors_max_age_seconds = 3000
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
