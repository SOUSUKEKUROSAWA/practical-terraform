module "example" {
    source = "../../modules/parameter-store"
    name = "example"
    description = "example"
    is_secure = true
}
