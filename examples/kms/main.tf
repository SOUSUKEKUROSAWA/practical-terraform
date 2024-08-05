module "example" {
    source = "../../modules/kms"
    name = "example"
    description = "example"
    is_enabled = false
    deletion_window_in_days = 7
}
