variable "name" {
    type = string
    description = "ECRのリポジトリ名"
}

variable "lifecycle_policy" {
    type = string
    description = "ECRライフサイクルポリシー（JSON）"
}
