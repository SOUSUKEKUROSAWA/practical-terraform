module "listener_rule" {
  source                      = "../modules/alb/listener-rule"
  listener_arn                = module.alb.listener_arn
  listener_rule_priority_rank = 100
  listener_rule_path_patterns = ["*"]
  target_group_name           = local.project_name
  target_type                 = "ip"
  target_vpc_id               = module.vpc.vpc_id

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

module "alb_sg" {
  source      = "../modules/network/secutiry-group"
  name        = "${local.project_name}-alb"
  vpc_id      = module.vpc.vpc_id
  port        = local.http_default_port
  cidr_blocks = ["0.0.0.0/0"]
}

module "ecs_nginx_sg" {
  source      = "../modules/network/secutiry-group"
  name        = "${local.project_name}-ecs-nginx"
  vpc_id      = module.vpc.vpc_id
  port        = local.http_default_port
  cidr_blocks = [local.vpc_cidr_block]
}

module "ecs_task_execution_role" {
  source = "../modules/iam-role/ecs-task-execution"
  prefix = local.project_name
}

module "cloudwatch_start_ecs_role" {
  count = local.create_batch ? 1 : 0

  source = "../modules/iam-role/cloudwatch_start_ecs"
  prefix = local.project_name
}

resource "aws_db_option_group" "mariadb_audit_plugin" {
  count = local.create_db ? 1 : 0

  name                 = local.project_name
  engine_name          = local.db_engine_name
  major_engine_version = local.db_engine_version

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

module "kms_key" {
  count = local.create_db ? 1 : 0

  source                  = "../modules/master-key"
  name                    = local.project_name
  description             = "For DB Disk Encryption"
  is_enabled              = true
  deletion_window_in_days = 7
}
