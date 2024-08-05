data "aws_iam_policy" "cloudwatch_start_ecs_role_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
