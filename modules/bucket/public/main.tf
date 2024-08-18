resource "aws_s3_bucket" "this" {
    bucket = var.name
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
