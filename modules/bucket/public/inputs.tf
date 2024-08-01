variable "name" {
    type = string
    description = "S3バケット名"
}

variable "enable_versioning" {
    type = bool
    description = "true の場合バケットのバージョニングを有効化"
    default = true
}

variable "cors_allowed_headers" {
    type = list(string)
    description = "クライアントがリクエストを送信する際に使用できるHTTPヘッダーのリスト"
    default = null
}

variable "cors_allowed_methods" {
    type = list(string)
    description = "クライアントがリクエストを送信する際に使用できるHTTPメソッドのリスト"
}

variable "cors_allowed_origins" {
    type = list(string)
    description = "リクエストを送信できるクライアントのオリジンのリスト"
}

variable "cors_expose_headers" {
    type = list(string)
    description = "サーバーがクライアントに返すレスポンスヘッダーのリスト"
    default = null
}

variable "cors_max_age_seconds" {
    type = number
    description = "プリフライト応答をブラウザがキャッシュする時間 (秒)"
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
