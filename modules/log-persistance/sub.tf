module "cloudwatch_logs_role" {
    source = "../iam-role"
    name = "cloudwatch-logs"
    identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.cloudwathc_logs.json
}

module "kinesis_data_firehose_role" {
    source = "../iam-role"
    name = "kinesis-data-firehose"
    identifiers = ["firehose.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.kinesis_data_firehose.json
}

resource "aws_s3_bucket_lifecycle_configuration" "rotation" {
    bucket = aws_s3_bucket.this.id
    rule {
        id = "rotation"
        expiration {
            days = var.log_expiration_days
        }
        status = "Enabled"
    }
}
