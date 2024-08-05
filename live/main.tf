module "vpc" {
    source = "../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr
    name = local.project_name
    public_subnet_cidr_blocks = local.public_subnet_cidr_blocks
    private_subnet_cidr_blocks = local.private_subnet_cidr_blocks
    availability_zones = local.availability_zones
}

module "alb_sg" {
    source = "../modules/network/secutiry-group"
    name = "${local.project_name}-alb"
    vpc_id = module.vpc.vpc_id
    port = local.http_default_port
    cidr_blocks = ["0.0.0.0/0"]
}

module "alb" {
    source = "../modules/alb"
    name = local.project_name
    security_group_ids = [module.alb_sg.security_group_id]
    public_subnet_ids = module.vpc.public_subnet_ids
}

module "listener_rule" {
    source = "../modules/alb/listener-rule"
    listener_arn = module.alb.listener_arn
    listener_rule_priority_rank = 100
    listener_rule_path_patterns = ["*"]
    target_group_name = local.project_name
    target_type = "ip"
    target_vpc_id = module.vpc.vpc_id

    # WARN: ALBが先に必要
    depends_on = [module.alb]
}

# ターゲットグループが先に作成されていないとApplyできないので新規作成時はコメントアウト
# module "additional_listener_rule" {
#     source = "../modules/alb/listener-rule"
#     listener_arn = module.alb.listener_arn
#     listener_rule_priority_rank = 90
#     listener_rule_path_patterns = ["/aaa"]
#     target_group_arn = <既存のターゲットグループのARN>

#     # WARN: ALBが先に必要
#     depends_on = [module.alb]
# }

module "ecs_nginx_sg" {
    source = "../modules/network/secutiry-group"
    name = "${local.project_name}-ecs-nginx"
    vpc_id = module.vpc.vpc_id
    port = local.http_default_port
    cidr_blocks = [local.vpc_cidr]
}

module "ecs" {
    source = "../modules/ecs-fargate"
    name = local.project_name
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    desired_count = 2
    platform_version = "1.4.0"
    security_group_ids = [module.ecs_nginx_sg.security_group_id]
    subnet_ids = module.vpc.private_subnet_ids
    target_group_arn = module.listener_rule.target_group_arn
    container_name = local.nginx_container_name
    container_port = local.http_default_port
    log_group_name = local.ecs_log_group_name

    container_definitions = jsonencode([
        {
            name = local.nginx_container_name
            image = local.nginx_container_image
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = data.aws_region.current.name
                    awslogs-stream-prefix = local.nginx_container_awslogs_stream_prefix
                    awslogs-group = local.ecs_log_group_name
                }
            }
            portMappings = [
                {
                    protocol = "tcp"
                    containerPort = local.http_default_port
                }
            ]
        }
    ])
}

module "ecs_task_execution_role" {
    source = "../modules/iam-role/ecs-task-execution"
    prefix = local.project_name
}
