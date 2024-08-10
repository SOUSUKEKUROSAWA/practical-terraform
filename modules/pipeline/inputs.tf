variable "name" {
    type = string
    description = "パイプライン名"
}

variable "codebuild_role_policy_document" {
    type = string
    description = "CodeBuildプロジェクトに付与するIAMロールポリシー（JSON）"
}

variable "codepipeline_role_policy_document" {
    type = string
    description = "CodePipelineに付与するIAMロールポリシー（JSON）"
}

variable "codebuild_source_type" {
    type = string
    description = "ビルド対象のファイルのタイプ"
    default = "CODEPIPELINE"
}

variable "codebuild_artifacts_type" {
    type = string
    description = "ビルド出力アーティファクトの格納先"
    default = "CODEPIPELINE"
}

variable "codebuild_environment_type" {
    type = string
    description = "ビルド環境のタイプ"
    default = "LINUX_CONTAINER"
}

variable "codebuild_compute_type" {
    type = string
    description = "ビルド環境のコンピュートタイプ"
    default = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
    type = string
    description = "ビルド環境で使用するイメージタイプ"
    default = "aws/codebuild/standard:2.0"
}

variable "enable_privileged_mode" {
    type = bool
    description = "trueの場合, 特権モードが有効になる. dockerコマンドを使う場合などはtrueにする必要がある"
}

variable "github_owner_name" {
    type = string
    description = "GitHubユーザー名（リポジトリのOwner）"
}

variable "github_target_repository_name" {
    type = string
    description = "対象のGitHubリポジトリ名"
}

variable "github_target_branch_name" {
    type = string
    description = "対象のGitHubブランチ名"
}

variable "enable_poll_for_source_changes" {
    type = bool
    description = "trueの場合, ポーリングが有効になる"
    default = false
}

variable "ecs_target_cluster_name" {
    type = string
    description = "対象のECSクラスター名"
}

variable "ecs_target_service_name" {
    type = string
    description = "対象のECSサービス名"
}
