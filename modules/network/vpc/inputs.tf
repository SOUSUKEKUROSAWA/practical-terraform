variable "cidr_block" {
    type = string
    description = "VPCのIPv4アドレス範囲. 後から変更できないことに注意"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "trueの場合, AWSのDNSサーバによる名前解決が有効になる"
}

variable "enable_dns_support" {
    type = bool
    description = "trueの場合, VPC内のリソースにパブリックDNSホスト名を自動的に割り当てる"
}

variable "name" {
    type = string
    description = "VPC名"
}

variable "public_subnets" {
    type = map(string)
    description = "パブリックサブネットのIPv4アドレス範囲とリージョンのマップ. 複数指定する場合, それぞれが重複してはいけない"
}

variable "private_subnets" {
    type = map(string)
    description = "プライベートサブネットのIPv4アドレス範囲とリージョンのマップ. 複数指定する場合, それぞれが重複してはいけない"
}
