variable "name" {
    type = string
    description = "EC2インスタンス名"
}

variable "ami" {
    type = string
    description = "EC2インスタンスのAMI"
}

variable "instance_type" {
    type = string
    description = "EC2インスタンスタイプ"
}

variable "subnet_id" {
    type = string
    description = "EC2インスタンスが属するサブネットID"
}

variable "log_retention_in_days" {
    type = number
    description = "ログ保存用S3バケットのローテーション周期（日）"
}
