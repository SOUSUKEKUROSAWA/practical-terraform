module "example" {
    source = "../../modules/ecr"
    name = "example"
    lifecycle_policy = jsonencode({
        rules = [
            {
                rulePriority = 1
                description = "Keep last 30 release tagged images"
                selection = {
                    tagStatus = "tagged"
                    tagPrefixList = ["release"]
                    countType = "imageCountMoreThan"
                    countNumber = 30
                }
                action = {
                    type = "expire"
                }
            }
        ]
    })
}
