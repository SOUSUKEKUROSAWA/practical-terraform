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
