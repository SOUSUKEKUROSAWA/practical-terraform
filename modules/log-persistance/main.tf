# 特定の CloudWatch Logs のロググループのログをフィルタリングして Kinesis Data firehose に送る
resource "aws_cloudwatch_log_subscription_filter" "this" {
    name = var.name
    log_group_name = var.log_group_name
    destination_arn = aws_kinesis_firehose_delivery_stream.this.arn
    filter_pattern = var.filter_pattern
    role_arn = module.cloudwatch_logs_role.arn
}

# CloudWatch Logs から受け取ったログを特定の S3 に保存する
# データ変換やバッファリングによる効率的な書き込みを担うミドルウェア
resource "aws_kinesis_firehose_delivery_stream" "this" {
    name = var.name
    destination = "extended_s3"
    extended_s3_configuration {
        role_arn = module.kinesis_data_firehose_role.arn
        bucket_arn = aws_s3_bucket.this.arn
        prefix = var.destination_s3_prefix
    }
}

# ログ永続化先のS3バケット
# CloudWatch Logs はストレージとしては割高なため安価な S3 にデータを写す
resource "aws_s3_bucket" "this" {
    bucket = "${var.name}-log-persistance"
}
