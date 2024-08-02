variable "name" {
    type = string
    description = "セキュリティグループ名"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}

variable "port" {
    type = number
    description = "セキュリティグループが許可するインバウンド通信のポート"
}

variable "cidr_blocks" {
    type = list(string)
    description = "セキュリティグループが許可するインバウンド通信のIPv4アドレス範囲"
}
