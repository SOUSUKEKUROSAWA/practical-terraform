module "vpc" {
    source = "../modules/network/vpc"
    cidr_block = local.vpc_cidr
    name = local.project_name
    public_subnets = {
        "${local.public_cidr_az_1}": "${local.az_1}",
        "${local.public_cidr_az_2}": "${local.az_2}",
    }
    private_subnets = {
        "${local.private_cidr_az_1}": "${local.az_1}",
        "${local.private_cidr_az_2}": "${local.az_2}",
    }
}

module "security_group" {
    source = "../modules/network/secutiry-group"
    name = "${local.project_name}-http"
    vpc_id = module.vpc.vpc_id
    port = local.http_default_port
    cidr_blocks = ["0.0.0.0/0"]
}

module "alb" {
    source = "../modules/alb"
    name = local.project_name
    security_group_ids = [module.security_group.security_group_id]
    public_subnets_ids = module.vpc.public_subnets_ids
}

module "listener_rule" {
    source = "../modules/alb/listener-rule"
    listener_arn = module.alb.listener_arn
    listener_rule_priority_rank = 100
    listener_rule_path_patterns = ["/"]
    target_group_name = local.project_name
    target_type = "ip"
    target_vpc_id = module.vpc.vpc_id

    # WARN: ALBが先に必要
    depends_on = [module.alb]
}

module "additional_listener_rule" {
    source = "../modules/alb/listener-rule"
    listener_arn = module.alb.listener_arn
    listener_rule_priority_rank = 90
    listener_rule_path_patterns = ["/aaa"]
    target_group_arn = module.listener_rule.target_group_arn

    # WARN: ALBが先に必要
    depends_on = [module.alb]
}
