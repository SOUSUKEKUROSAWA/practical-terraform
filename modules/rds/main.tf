resource "aws_db_parameter_group" "this" {
    name = var.name
    family = "${var.engine_name}${var.engine_version}"

    dynamic "parameter" {
        for_each = var.parameters

        content {
            name = parameter.key
            value = parameter.value
        }
    }
}

resource "aws_db_instance" "this" {
    identifier = var.name
    engine = var.engine_name
    engine_version = var.engine_version
    port = var.engine_port
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    max_allocated_storage = var.max_allocated_storage
    storage_type = var.storage_type
    storage_encrypted = var.storage_encrypted
    kms_key_id = var.storage_encrypted ? var.kms_key_arn : null
    username = var.master_username
    password = "xxxxxxxx" # WARN: ステートファイルにプレーンテキストで表示されてしまうため仮値を設定. Apply後すぐに更新すること
    multi_az = var.enable_multi_az
    publicly_accessible = false
    backup_window = var.backup_window_utc
    backup_retention_period = var.backup_retention_period
    maintenance_window = var.maintenance_window_utc
    auto_minor_version_upgrade = var.auto_minor_version_upgrade
    deletion_protection = var.deletion_protection
    skip_final_snapshot = var.skip_final_snapshot
    apply_immediately = false # 予期せぬダウンタイムを防ぐために, 即時反映を避ける
    vpc_security_group_ids = [module.db_sg.security_group_id]
    parameter_group_name = aws_db_parameter_group.this.name
    option_group_name = var.option_group_name
    db_subnet_group_name = aws_db_parameter_group.this.name

    lifecycle {
        ignore_changes = [password]
    }
}

module "db_sg" {
    source = "../network/secutiry-group"
    name = var.name
    vpc_id = var.vpc_id
    port = var.engine_port
    cidr_blocks = [var.vpc_cidr_block]
}

resource "aws_db_subnet_group" "this" {
    name = var.name
    subnet_ids = var.private_subnet_ids

    lifecycle {
        precondition {
            condition = var.enable_multi_az ? length(distinct(var.private_subnet_ids)) >= 2 : true
            error_message = "マルチAZを有効にする場合は, 異なるAZのサブネットを2つ以上指定してください"
        }
    }
}
