# SSMの接続対象のインスタンス
resource "aws_instance" "this" {
    ami = var.ami
    instance_type = var.instance_type
    iam_instance_profile = aws_iam_instance_profile.this.name
    subnet_id = var.subnet_id
    user_data = file("${path.module}/user_data.sh")
}

# SSMを可能にするロール
module "ssm_role" {
    source = "../iam-role"
    name = "${var.name}-ssm"
    identifiers = ["ec2.amazonaws.com"]
    policy_document = data.aws_iam_policy_document.ssm.json
}

# SSMを可能にするロールをEC2インスタンスに付与
# EC2は特殊で, インスタンスプロファイルを使って, インスタンスに直接アタッチする
resource "aws_iam_instance_profile" "this" {
    name = "${var.name}"
    role = "${var.name}-ssm"
}
