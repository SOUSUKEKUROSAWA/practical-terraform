module "codebuild_role" {
    source = "../iam-role"
    name = "${var.name}-codebuild"
    identifiers = ["codebuild.amazonaws.com"]
    policy_document = var.codebuild_role_policy_document
}

resource "aws_codebuild_project" "this" {
    name = var.name
    service_role = module.codebuild_role.arn

    source {
        type = var.codebuild_source_type
    }

    artifacts {
        type = var.codebuild_artifacts_type
    }

    environment {
        type = var.codebuild_environment_type
        compute_type = var.codebuild_compute_type
        image = var.codebuild_image
        privileged_mode = var.enable_privileged_mode
    }
}

module "codepipeline_role" {
    source = "../iam-role"
    name = "${var.name}-codepipeline"
    identifiers = ["codepipeline.amazonaws.com"]
    policy_document = var.codepipeline_role_policy_document
}

# TODO: 可能であればモジュールを利用する形に変更する
resource "aws_s3_bucket" "artifact" {
    bucket = "${var.name}-artifact"
}
resource "aws_s3_bucket_lifecycle_configuration" "rotation" {
    bucket = aws_s3_bucket.artifact.id
    rule {
        id = "rotation"
        expiration {
            days = "180"
        }
        status = "Enabled"
    }
}

resource "aws_codepipeline" "this" {
    name = var.name
    role_arn = module.codepipeline_role.arn

    stage {
        name = "Source"
        action {
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = 1
            output_artifacts = ["Source"]
            configuration = {
                ConnectionArn = aws_codestarconnections_connection.github.arn
                FullRepositoryId = "${var.github_owner_name}/${var.github_target_repository_name}"
                BranchName = var.github_target_branch_name
                OutputArtifactFormat = "CODEBUILD_CLONE_REF"
            }
        }
    }

    stage {
        name = "Build"
        action {
            name = "Build"
            category = "Build"
            owner = "AWS"
            provider = "CodeBuild"
            version = 1
            input_artifacts = ["Source"]
            output_artifacts = ["Build"]
            configuration = {
                ProjectName = aws_codebuild_project.this.name
            }
        }
    }

    stage {
        name = "Deploy"
        action {
            name = "Deploy"
            category = "Deploy"
            owner = "AWS"
            provider = "ECS"
            version = 1
            input_artifacts = ["Build"]
            configuration = {
                ClusterName = var.ecs_target_cluster_name
                ServiceName = var.ecs_target_service_name
                FileName = "imagedefinitions.json"
            }
        }
    }

    artifact_store {
        location = aws_s3_bucket.artifact.id
        type = "S3"
    }
}

resource "aws_codestarconnections_connection" "github" {
  name          = var.name
  provider_type = "GitHub"
}
