# TODO: 可能であればモジュールを利用する形に変更する
resource "aws_s3_bucket" "artifact" {
    bucket = "${var.name}-artifact"
}
resource "aws_s3_bucket_lifecycle_configuration" "rotation" {
    bucket = aws_s3_bucket.artifact.id
    rule {
        id = "rotation"
        expiration {
            days = "180"
        }
        status = "Enabled"
    }
}

resource "aws_codestarconnections_connection" "github" {
  name          = var.name
  provider_type = "GitHub"
}
