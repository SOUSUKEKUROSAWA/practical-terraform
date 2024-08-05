variable "name" {
    type = string
    description = "ECSクラスター名 兼 タスク定義名 兼 サービス名"
}

variable "cpu" {
    type = string
    description = "CPUユニット数. 1024 = 1vCPU どちらの指定方法でも可"
}

variable "memory" {
    type = string
    description = "メモリ容量. 1024 = 1GB どちらの指定方法でも可"
}

variable "container_definitions" {
    type = string
    description = "タスク定義（JSON）"
}

variable "ecs_task_execution_role_arn" {
    type = string
    description = "ECSのタスクを実行するためのIAMロールのARN"
}

variable "desired_count" {
    type = number
    description = "維持するタスク数. 本番環境では 2 以上を指定して, 可用性を高めることが推奨される"
}

variable "platform_version" {
    type = string
    description = "Fargateの利用バージョン. LATESTではなく, 固定のバージョンを指定することで意図せぬバージョンアップを防ぐことが推奨される"
}

variable "health_check_grace_period_seconds" {
    type = number
    description = "タスク起動時のヘルスチェック猶予期間（秒）. 十分長く設定しておかないとタスクの起動と終了が無限に続いてしまう可能性があるので注意"
    default = 60

    validation {
        condition = var.health_check_grace_period_seconds > 0
        error_message = "health_check_grace_period_seconds は 0 より大きな値を指定してください."
    }
}

variable "assign_public_ip" {
    type = bool
    description = "trueの場合タスクにパブリックIPを割り当てる"
    default = false
}

variable "security_group_ids" {
    type = list(string)
    description = "タスクが属するセキュリティグループのIDリスト"
}

variable "subnet_ids" {
    type = list(string)
    description = "タスクが属するサブネットのIDリスト"
}

variable "target_group_arn" {
    type = string
    description = "ALBターゲットグループのARN"
}

variable "container_name" {
    type = string
    description = "コンテナ定義の中で最初にロードバランサーからリクエストを受け取るコンテナ名"
}

variable "container_port" {
    type = number
    description = "コンテナ定義の中で最初にロードバランサーからリクエストを受け取るコンテナのポート番号"
}

variable "log_group_name" {
    type = string
    description = "CloudWatchのロググループ名"
}

variable "log_retention_in_days" {
    type = number
    description = "ログの保持期間（日）"
    default = 30
}
