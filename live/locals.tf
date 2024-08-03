locals {
    project_name = "practical-terraform"
    az_1 = "us-east-2a"
    az_2 = "us-east-2b"
    vpc_cidr = "10.0.0.0/16"
    public_cidr_az_1 = "10.0.1.0/24"
    public_cidr_az_2 = "10.0.2.0/24"
    private_cidr_az_1 = "10.0.65.0/24"
    private_cidr_az_2 = "10.0.66.0/24"
    http_default_port = 80
}
