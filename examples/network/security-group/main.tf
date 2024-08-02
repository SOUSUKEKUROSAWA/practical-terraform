module "example" {
    source = "../../../modules/network/secutiry-group"
    name = "example"
    vpc_id = data.aws_vpc.default.id
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

# 検証のためデフォルトのVPCを参照
data "aws_vpc" "default" {
    default = true
}
