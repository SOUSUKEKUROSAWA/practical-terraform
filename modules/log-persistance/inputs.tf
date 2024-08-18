variable "name" {
    type = string
    description = "CloudWatchLogsサブスクリプションフィルタ名 兼 Kinesis firehose Delivery Stream 名 兼 ログバケット名"
}

variable "log_group_name" {
    type = string
    description = "S3 に送りたい CloudWatch Logs のロググループ名"
}

variable "filter_pattern" {
    type = string
    description = "S3 に送りたい CloudWatch Logs のフィルターパターン"
    default = "[]"
}

variable "destination_s3_prefix" {
    type = string
    description = "送信先の S3 のパス"
}

variable "log_expiration_days" {
    type = number
    description = "ログの有効期限（日）"
    default = 30
}
