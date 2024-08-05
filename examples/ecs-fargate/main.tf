module "example" {
    source = "../../modules/ecs-fargate"
    name = "example"
    cpu = "256"
    memory = "512"
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    desired_count = 2
    platform_version = "1.4.0"
    security_group_ids = [module.nginx_sg.security_group_id]
    subnet_ids = module.vpc.private_subnet_ids
    target_group_arn = module.listener_rule.target_group_arn
    container_name = local.nginx_container_name
    container_port = local.nginx_container_port
    log_group_name = local.log_group_name

    container_definitions = jsonencode([
        {
            name = local.nginx_container_name
            image = "nginx:latest"
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = data.aws_region.current.name
                    awslogs-stream-prefix = "nginx"
                    awslogs-group = local.log_group_name
                }
            }
            portMappings = [
                {
                    protocol = "tcp"
                    containerPort = local.nginx_container_port
                }
            ]
        }
    ])
}

module "nginx_sg" {
    source = "../../modules/network/secutiry-group"
    name = "example-nginx"
    vpc_id = module.vpc.vpc_id
    port = 80
    cidr_blocks = [local.vpc_cidr_blocks]
}

module "vpc" {
    source = "../../modules/network/vpc-2az"
    cidr_block = local.vpc_cidr_blocks
    name = "example"
    public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidr_blocks = ["10.0.65.0/24", "10.0.66.0/24"]
    availability_zones = ["us-east-2a", "us-east-2b"]
}

module "alb" {
    source = "../../modules/alb"
    name = "example"
    security_group_ids = [module.alb_sg.security_group_id]

    # WARN: ELBv2 ALB は，異なるAZに少なくとも２つのサブネットを作成する必要がある
    public_subnet_ids = module.vpc.public_subnet_ids
}

module "alb_sg" {
    source = "../../modules/network/secutiry-group"
    name = "example-alb"
    vpc_id = module.vpc.vpc_id
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

module "listener_rule" {
    source = "../../modules/alb/listener-rule"
    listener_arn = module.alb.listener_arn
    listener_rule_priority_rank = 100
    listener_rule_path_patterns = ["/"]
    target_group_name = "example"
    target_type = "ip"
    target_vpc_id = module.vpc.vpc_id

    # WARN: ALBが先に必要
    depends_on = [module.alb]
}

module "ecs_task_execution_role" {
    source = "../../modules/iam-role/ecs-task-execution"
    prefix = "example"
}
