resource "aws_ssm_parameter" "this" {
    name = var.name
    value = "xxx" # Apply後適切な値に更新すること
    type = var.is_secure ? "SecureString" : "String"
    description = var.description

    lifecycle {
        ignore_changes = [value]
    }
}
