variable "name" {
    type = string
    description = "データベース名"
}

variable "engine" {
    type = string
    description = "DBエンジン名. 'mysql' 'postgres' など"
}

variable "engine_version" {
    type = string
    description = "DBエンジンのバージョン番号"
}

variable "port" {
    type = number
    description = "DBエンジンのポート番号"
}

variable "parameters" {
    type = map(string)
    description = "DB設定のマップ"
    default = {}
}

variable "instance_class" {
    type = string
    description = "DBインスタンスクラス"
}

variable "allocated_storage" {
    type = number
    description = "ストレージ容量"
}

variable "max_allocated_storage" {
    type = number
    description = "最大ストレージ容量. ここで指定した容量まで自動的にスケールする"
}

variable "storage_type" {
    type = string
    description = "ストレージタイプ"
    default = "gp2"

    validation {
        condition = contains(["standard", "gp2", "gp3", "io1"], var.storage_type)
        error_message = "storage_type は 'standard','gp2','gp3','io1' の中から指定してください."
    }
}

variable "storage_encrypted" {
    type = bool
    description = "trueの場合ディスク暗号化が有効になる"
    default = true
}

variable "kms_key_arn" {
    type = string
    description = "KMS鍵のARN. ディスク暗号化に利用する. デフォルトのKMS鍵を使用するとアカウントをまたいだスナップショットの共有ができなくなるため, 自身で作成した鍵を使用すること"
    default = null
}

variable "master_username" {
    type = string
    description = "DBのマスターユーザー名. パスワードは仮値がセットされるため, Apply後に必ず手動で更新すること"
}

variable "enable_multi_az" {
    type = bool
    description = "trueの場合マルチAZ化が有効になる. ただし異なるAZのプライベートサブネットが指定されることが前提"
    default = true
}

variable "backup_window_utc" {
    type = string
    description = "毎日の自動バックアップが行われる時間帯（UTC）. 例 '09:10-09:40'"
}

variable "backup_retention_period" {
    type = number
    description = "バックアップ期間（日）"
    default = 30
}

variable "maintenance_window_utc" {
    type = string
    description = "定期的な自動メンテナンスが行われる曜日と時間帯（UTC）. 例 'sun:05:00-sun:07:00'. メンテナンスにはOSやDBエンジンの更新が含まれ, 無効にすることはできない"
}

variable "auto_minor_version_upgrade" {
    type = bool
    description = "falseの場合自動のマイナーバージョンアップが無効になる"
    default = false
}

variable "deletion_protection" {
    type = bool
    description = "trueの場合削除保護が有効になる. 削除したい場合は false にしたうえで, skip_final_snapshot を true にして Apply し，その後 destroy する必要がある"
    default = true
}

variable "skip_final_snapshot" {
    type = bool
    description = "falseの場合, インスタンスが削除される前にDBスナップショットが作成される"
    default = false
}

variable "option_group_name" {
    type = string
    description = "オプショングループ名. WARN: オプショングループリソースはモジュール外で作成する必要あり（モジュール内でオプショングループは作成されない）"
}

variable "vpc_id" {
    type = string
    description = "RDSが配置されるVPCのID"
}

variable "vpc_cidr_block" {
    type = string
    description = "RDSが配置されるVPCのIPv4アドレス範囲"
}

variable "private_subnet_ids" {
    type = list(string)
    description = "RDSが配置されるプライベートサブネットのIDリスト"
}
