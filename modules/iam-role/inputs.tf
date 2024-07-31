variable "name" {
    type = string
    description = "IAMロール名兼ポリシー名"
}

variable "identifiers" {
    type = list(string)
    description = "関連付けることが可能なリソース種"
}

variable "policy_document" {
    type = string
    description = "IAMポリシードキュメント（JSON）"
}
