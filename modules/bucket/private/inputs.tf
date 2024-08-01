variable "name" {
    type = string
    description = "S3バケット名"
}

variable "enable_versioning" {
    type = bool
    description = "true の場合バケットのバージョニングを有効化"
    default = true
}

variable "enable_log_rotation" {
    type = bool
    description = "true の場合S3バケットのファイルを log_expiration_days で指定した日数で削除"
    default = false
}

variable "log_expiration_days" {
    type = number
    description = "ログの保持期間（日）"
    default = null
}

variable "policy_document" {
    type = string
    description = "S3バケットポリシー（JSON）"
}
