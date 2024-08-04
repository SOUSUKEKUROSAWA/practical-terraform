module "example" {
    source = "../../../modules/network/vpc-2az"
    cidr_block = "10.0.0.0/16"
    name = "example"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
}
