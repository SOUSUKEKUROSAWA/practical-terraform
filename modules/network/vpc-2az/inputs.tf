variable "cidr_block" {
    type = string
    description = "VPCのIPv4アドレス範囲. 後から変更できないことに注意"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "trueの場合, AWSのDNSサーバによる名前解決が有効になる"
    default = true
}

variable "enable_dns_support" {
    type = bool
    description = "trueの場合, VPC内のリソースにパブリックDNSホスト名を自動的に割り当てる"
    default = true
}

variable "name" {
    type = string
    description = "VPC名"
}

variable "public_subnet_cidr_blocks" {
    type = list(string)
    description = "パブリックサブネットのIPv4アドレス範囲を2つ指定. それぞれが重複してはいけない"

    validation {
        condition = length(distinct(var.public_subnet_cidr_blocks)) == 2
        error_message = "パブリックサブットのIPv4アドレス範囲は重複しないものを 2 つ指定してください."
    }
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
    description = "プライベートサブネットのIPv4アドレス範囲を2つ指定. それぞれが重複してはいけない"

    validation {
        condition = length(distinct(var.private_subnet_cidr_blocks)) == 2
        error_message = "プライベートサブットのIPv4アドレス範囲は重複しないものを 2 つ指定してください."
    }
}

variable "availability_zones" {
    type = list(string)
    description = "サブネットを配置するアベイラビリティゾーンを2つ指定. それぞれが重複してはいけない"

    validation {
        condition = length(distinct(var.availability_zones)) == 2
        error_message = "アベイラビリティゾーンは重複しないものを 2 つ指定してください."
    }
}
