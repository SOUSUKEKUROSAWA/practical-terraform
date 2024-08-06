variable "name" {
    type = string
    description = "カスタマーマスターキー名"
}

variable "description" {
    type = string
    description = "カスタマーマスターキーの説明"
}

variable "enable_key_rotation" {
    type = bool
    description = "trueの場合, 年に一度キーが自動ローテーションされる. 復号に必要な古い暗号化マテリアルは保存されるため, ローテーション前に暗号化したデータの復号は問題なく行える"
    default = true
}

variable "is_enabled" {
    type = bool
    description = "trueの場合カスタマーキーが有効化される. 一時的に無効化したい時などは false にする"
    default = true
}

variable "deletion_window_in_days" {
    type = number
    description = "削除待期期間（日）. 削除を実行してもここで設定した期間中は削除を取り消せる. そもそも削除すること自体が非推奨なため, なるべく一時的な無効化などで対処すること"
    default = 30

    validation {
        condition = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
        error_message = "削除待期日数は 7日 から 30日 の間で指定してください."
    }
}
