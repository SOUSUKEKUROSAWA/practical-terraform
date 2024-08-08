variable "name" {
    type = string
    description = "キャッシュサーバ名"
}

variable "description" {
    type = string
    description = "キャッシュサーバの概要"
}

variable "engine" {
    type = string
    description = "キャッシュサーバのエンジン名. 'redis' か 'memcached' を設定すること"

    validation {
        condition = contains(["redis", "memcached"], var.engine)
        error_message = "engine は 'redis' か 'memcached' を設定してください"
    }
}

variable "engine_version" {
    type = string
    description = "キャッシュサーバのエンジンバージョン"
}

variable "engine_version_with_minor" {
    type = string
    description = "マイナーバージョンまでを含んだキャッシュサーバのエンジンバージョン"
}

variable "port" {
    type = number
    description = "キャッシュサーバのポート番号"
}

variable "parameters" {
    type = map(string)
    description = "キャッシュサーバ設定のマップ"
    default = {}
}

variable "private_subnet_ids" {
    type = list(string)
    description = "キャッシュサーバが配置されるプライベートサブネットのIDリスト"
}

variable "num_cache_clusters" {
    type = number
    description = "ノード数. プライマリノードとレプリカノードの合計値を指定すること"
}

variable "instance_class" {
    type = string
    description = "使用されるインスタンスクラス"
}

variable "snapshot_window_utc" {
    type = string
    description = "毎日の自動スナップショット作成が行われる時間帯（UTC）. 例 '09:10-09:40'"
}

variable "snapshot_retention_limit" {
    type = number
    description = "スナップショットの保持期間（日）. キャッシュとして利用する場合, 長期保存は不要"
    default = 7
}

variable "maintenance_window_utc" {
    type = string
    description = "定期的な自動メンテナンスが行われる曜日と時間帯（UTC）. 例 'sun:05:00-sun:07:00'"
}

variable "enable_automatic_failover" {
    type = bool
    description = "trueの場合, 自動フェイルオーバーが有効になる"
    default = true
}

variable "vpc_id" {
    type = string
    description = "キャッシュサーバが配置されるVPCのID"
}

variable "vpc_cidr_block" {
    type = string
    description = "キャッシュサーバが配置されるVPCのIPv4アドレス範囲"
}
