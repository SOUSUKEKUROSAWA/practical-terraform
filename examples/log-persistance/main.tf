module "example" {
    source = "../../modules/log-persistance"
    name = "example"
    log_group_name = local.log_group_name
    destination_s3_prefix = "example/"
    log_expiration_days = local.retention_in_days
}
