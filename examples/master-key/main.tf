module "example" {
    source = "../../modules/master-key"
    name = "example"
    description = "example"
    is_enabled = false
    deletion_window_in_days = 7
}
