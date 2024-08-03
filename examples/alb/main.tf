module "example" {
    source = "../../modules/alb"
    name = "example"
    security_group_ids = [module.security_group.security_group_id]

    # WARN: ELBv2 ALB は，異なるAZに少なくとも２つのサブネットを作成する必要がある
    public_subnets_ids = module.vpc.public_subnets_ids
}

module "vpc" {
    source = "../../modules/network/vpc"
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    name = "example"
    public_subnets = {
        "10.0.1.0/24": "us-east-2a",
        "10.0.2.0/24": "us-east-2b",
    }
    private_subnets = {
        "10.0.65.0/24": "us-east-2a",
        "10.0.66.0/24": "us-east-2b",
    }
}

module "security_group" {
    source = "../../modules/network/secutiry-group"
    name = "example"
    vpc_id = module.vpc.vpc_id
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

module "listener-rule" {
    source = "../../modules/alb/listener-rule"
    listener_arn = module.example.listener_arn
    listener_rule_priority_rank = 100
    listener_rule_path_patterns = ["/"]
    target_group_name = "example"
    target_type = "ip"
    target_vpc_id = module.vpc.vpc_id

    # WARN: ALBが先に必要
    depends_on = [module.example]
}


