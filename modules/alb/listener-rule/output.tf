output "target_group_arn" {
    value = var.target_group_arn != "" ? var.target_group_arn : aws_lb_target_group.this[0].arn
}
