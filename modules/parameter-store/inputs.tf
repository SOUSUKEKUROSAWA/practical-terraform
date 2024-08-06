variable "name" {
    type = string
    description = "パラメータ名"
}

variable "description" {
    type = string
    description = "パラメータについての説明"
}

variable "is_secure" {
    type = bool
    description = "trueの場合パラメータは暗号化されて保存され, 読み出し時は復号する必要がある"
}
