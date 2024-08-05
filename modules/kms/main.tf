resource "aws_kms_key" "this" {
    description = var.description
    enable_key_rotation = var.enable_key_rotation
    is_enabled = var.is_enabled
    deletion_window_in_days = var.deletion_window_in_days
}

resource "aws_kms_alias" "this" {
    # WARN: 'alias/' というプレフィックスが必須
    name = "alias/${var.name}"
    target_key_id = aws_kms_key.this.key_id
}
