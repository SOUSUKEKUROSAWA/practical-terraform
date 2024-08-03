variable "listener_arn" {
    type = string
    description = "リスナールールを追加するリスナーのARN"
}

variable "listener_rule_priority_rank" {
    type = number
    description = "リスナールールの優先順位. 小さい値ほど優先度が高い"
}

variable "listener_rule_path_patterns" {
    type = list(string)
    description = "リスナールールにマッチするパスパターンのリスト"
    default = []
}

variable "target_group_name" {
    type = string
    description = "ターゲットグループ名"
}

variable "target_type" {
    type = string
    description = "ターゲットのタイプ. instance か ip を指定すること."
    default = "instance"

    validation {
        condition = contains(["instance", "ip"], var.target_type)
        error_message = "target_type must be instance or ip."
    }
}

variable "target_vpc_id" {
    type = string
    description = "ターゲットグループが属するVPCのID"
}

variable "target_port" {
    type = number
    description = "ルーティング先のポート番号. 一般的にはALBがHTTPSの終端になるので, HTTPSを使用していても, ここにはHTTPのデフォルトポートが設定されることが多い"
    default = 80
}

variable "target_protocol" {
    type = string
    description = "ルーティング先のプロトコル. 一般的にはALBがHTTPSの終端になるので, HTTPSを使用していても, ここにはHTTPが設定されることが多い"
    default = "HTTP"
}

variable "target_deregistration_delay_seconds" {
    type = number
    description = "ターゲットの登録解除までの待機時間（秒）"
    default = 300
}

variable "health_check_path" {
    type = string
    description = "ヘルスチェックで使用するパス"
    default = "/"
}

variable "try_count_for_healthy" {
    type = number
    description = "正常判定を行うまでのヘルスチェック実行回数"
    default = 5
}

variable "try_count_for_unhealthy" {
    type = number
    description = "異常判定を行うまでのヘルスチェック実行回数"
    default = 2
}

variable "health_check_timeout_seconds" {
    type = number
    description = "ヘルスチェックのタイムアウト時間（秒）"
    default = 5
}

variable "health_check_interval_seconds" {
    type = number
    description = "ヘルスチェックの実行間隔（秒）"
    default = 30
}
