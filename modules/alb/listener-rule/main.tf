resource "aws_lb_listener_rule" "this" {
    listener_arn = var.listener_arn

    # 優先順位のランク（100なら第100位）
    priority = var.listener_rule_priority_rank

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.this.arn
    }

    condition {
        path_pattern {
            values = var.listener_rule_path_patterns
        }
    }
}

resource "aws_lb_target_group" "this" {
    name = var.target_group_name
    target_type = var.target_type
    vpc_id = var.target_vpc_id
    port = var.target_port
    protocol = var.target_protocol

    deregistration_delay = var.target_deregistration_delay_seconds

    health_check {
        path = var.health_check_path
        healthy_threshold = var.try_count_for_healthy
        unhealthy_threshold = var.try_count_for_unhealthy
        timeout = var.health_check_timeout_seconds
        interval = var.health_check_interval_seconds
        matcher = 200
        port = "traffic-port" # aws_lb_target_group.this.port を使用する設定
        protocol = "HTTP"
    }
}
