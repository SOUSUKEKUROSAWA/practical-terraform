module "example" {
    source = "../../modules/iam-role"
    name = "example"
    identifiers = ["ec2.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
    statement {
        effect = "Allow"
        actions = ["ec2:DescribeRegions"]
        resources = ["*"]
    }
}
