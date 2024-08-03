resource "aws_lb" "this" {
    name = var.name
    load_balancer_type = "application"
    internal = false
    idle_timeout = var.timeout_seconds
    subnets = var.public_subnets_ids
    security_groups = var.security_group_ids

    access_logs {
        enabled = var.enable_logging
        bucket = var.log_bucket_id
    }

    enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.this.arn
    port = var.enable_https ? "443" : "80"
    protocol = var.enable_https ? "HTTPS" : "HTTP"
    certificate_arn = var.enable_https ? var.certificate_arn : null
    ssl_policy = var.enable_https ? var.ssl_policy : null

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = var.default_response_message
            status_code = 400
        }
    }
}

resource "aws_lb_listener" "redirect_http_to_https" {
    count = var.enable_https ? 1 : 0

    load_balancer_arn = aws_lb.this.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}
