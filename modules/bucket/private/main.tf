resource "aws_s3_bucket" "this" {
    bucket = var.name
}

resource "aws_s3_bucket_versioning" "this" {
    bucket = aws_s3_bucket.this.id
    versioning_configuration {
        status = var.enable_versioning ? "Enabled" : "Disabled"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
    bucket = aws_s3_bucket.this.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "log_rotation" {
    count = var.enable_log_rotation ? 1 : 0

    bucket = aws_s3_bucket.this.id
    rule {
        id = "Log"
        filter {
            prefix = "logs/"
        }
        expiration {
            days = var.log_expiration_days
        }
        status = "Enabled"
    }
}

resource "aws_s3_bucket_policy" "this" {
    bucket = aws_s3_bucket.this.id
    policy = var.policy_document
}
