module "example" {
    source = "../../modules/ec2-for-ssm"
    name = "example-ec2-for-ssm"
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnets.default.ids[0]
    log_retention_in_days = 180
}
