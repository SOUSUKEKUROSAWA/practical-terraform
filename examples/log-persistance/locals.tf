locals {
    log_group_name = "example"
    retention_in_days = 30
}

# サンプルリソースのためロググループだけ定義
# 実際にはECSリソース群を作成して，そこで作成したロググループの名前などを渡す
resource "aws_cloudwatch_log_group" "for_ecs" {
    name = local.log_group_name
    retention_in_days = local.retention_in_days
}
