resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support
    tags = {
        Name = var.name
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
}

# VPC（local）以外への通信を，インターネットゲートウェイ経由でインターネットへ流す
resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    
    # マッチしたトラフィックの送り先
    gateway_id = aws_internet_gateway.this.id

    # デフォルトルート（全てにマッチする）
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "public" {
    for_each = var.public_subnets

    vpc_id = aws_vpc.this.id
    cidr_block = each.key
    availability_zone = each.value
    map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
    for_each = var.public_subnets

    subnet_id = aws_subnet.public[each.key].id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
    for_each = var.private_subnets

    vpc_id = aws_vpc.this.id
    cidr_block = each.key
    availability_zone = each.value
    map_public_ip_on_launch = false
}

# NATゲートウェイのパブリックIPを固定
resource "aws_eip" "nat_gateway" {
    for_each = var.private_subnets

    # EIPをVPC内のリソース（NATゲートウェイなど）に使用する場合，必須
    domain = "vpc"

    # インターネットゲートウェイが先に作成されている必要がある
    depends_on = [aws_internet_gateway.this]
}

# プライベートIPアドレスを持つリソースがインターネットに出る際に、
# NATゲートウェイがそのIPアドレスをパブリックIPアドレスに変換する
resource "aws_nat_gateway" "this" {
    for_each = var.private_subnets

    # valuesでマップをリストに変換
    allocation_id = aws_eip.nat_gateway[each.key].id
    subnet_id = aws_subnet.private[each.key].id
    depends_on = [aws_internet_gateway.this]
}

# NATゲートウェイがプライベートサブネットごとにあるため，
# ルートテーブルもプライベートサブネットごとに必要
resource "aws_route_table" "private" {
    for_each = var.private_subnets

    vpc_id = aws_vpc.this.id
}

resource "aws_route" "private" {
    for_each = var.private_subnets

    route_table_id = aws_route_table.private[each.key].id
    nat_gateway_id = aws_nat_gateway.this[each.key].id
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
    for_each = var.private_subnets

    subnet_id = aws_subnet.private[each.key].id
    route_table_id = aws_route_table.private[each.key].id
}
