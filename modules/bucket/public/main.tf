resource "aws_s3_bucket" "this" {
    bucket = var.name
}

resource "aws_s3_bucket_versioning" "this" {
    bucket = aws_s3_bucket.this.id
    versioning_configuration {
        status = var.enable_versioning ? "Enabled" : "Disabled"
    }
}

resource "aws_s3_bucket_cors_configuration" "this" {
    bucket = aws_s3_bucket.this.id
    cors_rule {
        allowed_headers = var.cors_allowed_headers
        allowed_methods = var.cors_allowed_methods
        allowed_origins = var.cors_allowed_origins
        expose_headers  = var.cors_expose_headers
        max_age_seconds = var.cors_max_age_seconds
    }
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
