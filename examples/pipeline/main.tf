module "example" {
  source = "../../modules/pipeline"

  name = "practical-terraform" # S3バケットの命名は全世界で一意である必要があるため
  codebuild_role_policy_document = data.aws_iam_policy_document.codebuild.json
  codepipeline_role_policy_document = data.aws_iam_policy_document.codepipeline.json
  enable_privileged_mode = true # dockerコマンド実行のため
  github_owner_name = "SOUSUKEKUROSAWA"
  github_target_repository_name = "practical-terraform"
  github_target_branch_name = "main"
  ecs_target_cluster_name = "your-ecs-cluster"
  ecs_target_service_name = "your-ecs-service"
  github_webhook_secret_token = "your-secret-token"
}

data "aws_iam_policy_document" "codebuild" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImage",
            "ecr:BatchGetImage",
            "ecr:InitialLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
        ]
        resources = [
            "*"
        ]
    }
}

data "aws_iam_policy_document" "codepipeline" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "ecs:DescribeServices",
            "ecs:DescribeTasks",
            "ecs:ListTasks",
            "ecs:RegisterTaskDefinition",
            "ecs:UpdateService",
            "iam:PassRole",
        ]
        resources = [
            "*"
        ]
    }
}
