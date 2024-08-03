variable "name" {
    type = string
    description = "ロードバランサー名兼ターゲットグループ名"
}

variable "timeout_seconds" {
    type = number
    description = "タイムアウト（秒）"
    default = 60
}

variable "enable_deletion_protection" {
    type = bool
    description = "trueの場合Terraformからロードバランサーが削除できなくなる. 本番環境では true に設定することを推奨"
    default = false
}

variable "public_subnets_ids" {
    type = list(string)
    description = "ロードバランサーが負荷分散を行う, パブリックサブネットのIDリスト"
}

variable "security_group_ids" {
    type = list(string)
    description = "ロードバランサーに適用する, セキュリティグループのIDリスト"
}

variable "enable_https" {
    type = bool
    description = "trueの場合HTTPS用にロードバランサーを構成する"
    default = false
}

variable "enable_logging" {
    type = bool
    description = "trueの場合アクセスログが有効になり, ログバケットの指定が必須になる"
    default = false
}

variable "log_bucket_id" {
    type = string
    description = "アクセスログを保存するS3バケットのID"
    default = ""
}

variable "certificate_arn" {
    type = string
    description = "SSL証明書のARN. HTTPSの場合必須"
    default = null
}

variable "ssl_policy" {
    type = string
    description = "セキュリティポリシー. HTTPSの場合必須"
    default = null
}

variable "default_response_message" {
    type = string
    description = "いずれのリスナールールにも合致しない場合に返却するメッセージ"
    default = "Not Found"
}
