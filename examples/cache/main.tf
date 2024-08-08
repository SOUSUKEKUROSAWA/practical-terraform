module "example" {
    source = "../../modules/cache"
    name = "example"
    description = "example"
    engine = "redis"
    engine_version = "5.0"
    engine_version_with_minor = "5.0.6"
    port = 6379
    parameters = {
        cluster-enabled = "no"
    }
    private_subnet_ids = module.vpc.private_subnet_ids
    num_cache_clusters = 3
    instance_class = "cache.m5.large"
    snapshot_window_utc = "09:10-10:10"
    maintenance_window_utc = "mon:10:40-mon:11:40"
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
}

module "vpc" {
    source = "../../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_block
    name = "example"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
}
