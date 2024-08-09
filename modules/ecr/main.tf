resource "aws_ecr_repository" "this" {
    name = var.name
}

resource "aws_ecr_lifecycle_policy" "this" {
    repository = aws_ecr_repository.this.name
    policy = var.lifecycle_policy
}
