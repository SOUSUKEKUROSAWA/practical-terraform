data "aws_region" "current" {}

data "aws_iam_policy_document" "cloudwathc_logs" {
    statement {
        effect = "Allow"
        actions = [
            "firehose:*"
        ]
        resources = [
            "arn:aws:firehose:${data.aws_region.current.name}:*:*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "iam:PassRole"
        ]
        resources = [
            module.cloudwatch_logs_role.arn
        ]
    }
}

data "aws_iam_policy_document" "kinesis_data_firehose" {
    statement {
        effect = "Allow"
        actions = [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
        ]
        resources = [
            aws_s3_bucket.this.arn,
            "${aws_s3_bucket.this.arn}/*"
        ]
    }
}
