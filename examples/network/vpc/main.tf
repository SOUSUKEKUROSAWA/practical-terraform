module "example" {
    source = "../../../modules/network/vpc"
    cidr_block = "10.0.0.0/16"
    name = "example"
    public_subnets = {
        "10.0.1.0/24": "us-east-2a",
        "10.0.2.0/24": "us-east-2b"
    }
    private_subnets = {
        "10.0.65.0/24": "us-east-2a",
        "10.0.66.0/24": "us-east-2b"
    }
}
