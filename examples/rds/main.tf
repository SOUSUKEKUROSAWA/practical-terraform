module "example" {
    source = "../../modules/rds"
    name = local.name
    engine_name = local.engine_name
    engine_version = local.engine_version
    engine_port = 3306
    parameters = {
        character_set_database = local.character_set
        character_set_server = local.character_set
    }
    instance_class = "db.t3.small"
    allocated_storage = 20
    max_allocated_storage = 100
    storage_type = "gp2"
    kms_key_arn = module.kms_key.arn
    master_username = "example"
    enable_multi_az = true
    backup_window_utc = "09:10-09:40"
    maintenance_window_utc = "mon:10:10-mon:10:40"
    option_group_name = aws_db_option_group.example.name
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
    private_subnet_ids = module.vpc.private_subnet_ids

    # インスタンスを削除する際に追加するパラメータ
    # deletion_protection = false
    # skip_final_snapshot = true
}

resource "aws_db_option_group" "example" {
    name = local.name
    engine_name = local.engine_name
    major_engine_version = local.engine_version

    option {
        option_name = "MARIADB_AUDIT_PLUGIN"
    }
}

module "kms_key" {
    source = "../../modules/master-key"
    name = "example"
    description = "example"
    is_enabled = true
    deletion_window_in_days = 7
}

module "vpc" {
    source = "../../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_block
    name = "example"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
}
