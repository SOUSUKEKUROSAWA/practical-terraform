variable "batch_id" {
    type = string
    description = "バッチID"
}

variable "batch_name" {
    type = string
    description = "バッチ名"
}

variable "batch_schedule_expression" {
    type = string
    description = "バッチの実行スケジュール式. 例: cron(0 8 * * ? *), rate(5 minutes)"
}

variable "batch_description" {
    type = string
    description = "バッチ処理の概要"
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

variable "cloudwatch_start_ecs_role_arn" {
    type = string
    description = "CloudWatchからECSタスクを起動するためのIAMロールのARN"
}

variable "ecs_cluster_arn" {
    type = string
    description = "ECSクラスタのARN"
}

variable "platform_version" {
    type = string
    description = "Fargateの利用バージョン. LATESTではなく, 固定のバージョンを指定することで意図せぬバージョンアップを防ぐことが推奨される"
}

variable "assign_public_ip" {
    type = bool
    description = "trueの場合タスクにパブリックIPを割り当てる"
    default = false
}

variable "subnet_ids" {
    type = list(string)
    description = "タスクが使用するサブネットのIDリスト"
}

variable "log_group_name" {
    type = string
    description = "CloudWatch のロググループ名"

    validation {
        condition = can(regex("^/ecs-scheduled-tasks/.*", var.log_group_name))
        error_message = "log_group_name は '/ecs-scheduled-tasks/' で始まる必要があります."
    }
}

variable "log_retention_in_days" {
    type = number
    description = "ログの保持期間（日）"
    default = 30
}
