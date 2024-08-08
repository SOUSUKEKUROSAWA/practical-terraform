resource "aws_elasticache_parameter_group" "this" {
    name = var.name
    family = "${var.engine}${var.engine_version}"

    dynamic "parameter" {
        for_each = var.parameters

        content {
            name = parameter.key
            value = parameter.value
        }
    }
}

resource "aws_elasticache_subnet_group" "this" {
    name = var.name
    subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
    replication_group_id = var.name
    description = var.description
    engine = var.engine
    engine_version = var.engine_version_with_minor
    num_cache_clusters = var.num_cache_clusters
    node_type = var.instance_class
    snapshot_window = var.snapshot_window_utc
    snapshot_retention_limit = var.snapshot_retention_limit
    maintenance_window = var.maintenance_window_utc
    automatic_failover_enabled = var.enable_automatic_failover
    port = var.port
    apply_immediately = false # 予期せぬダウンタイムを防ぐために, 即時反映を避ける
    security_group_ids = [module.cache_sg.security_group_id]
    parameter_group_name = aws_elasticache_parameter_group.this.name
    subnet_group_name = aws_elasticache_subnet_group.this.name

    lifecycle {
        precondition {
            condition = var.enable_automatic_failover ? length(distinct(var.private_subnet_ids)) >= 2 : true
            error_message = "自動フェイルオーバーを有効にする場合は, 異なるAZのサブネットを2つ以上指定してください"
        }
    }
}

module "cache_sg" {
    source = "../network/secutiry-group"
    name = var.name
    vpc_id = var.vpc_id
    port = var.port
    cidr_blocks = [var.vpc_cidr_block]
}
