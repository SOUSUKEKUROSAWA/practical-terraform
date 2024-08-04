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

resource "aws_subnet" "public_az0" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnet_cidr_blocks[0]
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = true
}
resource "aws_subnet" "public_az1" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnet_cidr_blocks[1]
    availability_zone = var.availability_zones[1]
    map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public_az0" {
    subnet_id = aws_subnet.public_az0.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_az1" {
    subnet_id = aws_subnet.public_az1.id
    route_table_id = aws_route_table.public.id
}

# NATゲートウェイのパブリックIPを固定
resource "aws_eip" "for_nat_gateway_az0" {
    # EIPをVPC内のリソース（NATゲートウェイなど）に使用する場合，必須
    domain = "vpc"

    # インターネットゲートウェイが先に作成されている必要がある
    depends_on = [aws_internet_gateway.this]
}
resource "aws_eip" "for_nat_gateway_az1" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.this]
}

# プライベートIPアドレスを持つリソースがインターネットに出る際に、
# NATゲートウェイがそのIPアドレスをパブリックIPアドレスに変換する
# WARN: NATゲートウェイ自体はパブリックサブネットに配置される
resource "aws_nat_gateway" "az0" {
    allocation_id = aws_eip.for_nat_gateway_az0.id

    # NATゲートウェイを配置するパブリックサブネットのID
    subnet_id = aws_subnet.public_az0.id

    depends_on = [aws_internet_gateway.this]
}
resource "aws_nat_gateway" "az1" {
    allocation_id = aws_eip.for_nat_gateway_az1.id

    # NATゲートウェイを配置するパブリックサブネットのID
    subnet_id = aws_subnet.public_az1.id

    depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "private_az0" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnet_cidr_blocks[0]
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = false
}
resource "aws_subnet" "private_az1" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnet_cidr_blocks[1]
    availability_zone = var.availability_zones[1]
    map_public_ip_on_launch = false
}

# NATゲートウェイがサブネットごとにあるため，
# ルートテーブルもサブネットごとに必要
resource "aws_route_table" "private_az0" {
    vpc_id = aws_vpc.this.id
}
resource "aws_route_table" "private_az1" {
    vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_az0" {
    route_table_id = aws_route_table.private_az0.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az0.id
}
resource "aws_route" "private_az1" {
    route_table_id = aws_route_table.private_az1.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1.id
}

resource "aws_route_table_association" "private_az0" {
    subnet_id = aws_subnet.private_az0.id
    route_table_id = aws_route_table.private_az0.id
}
resource "aws_route_table_association" "private_az1" {
    subnet_id = aws_subnet.private_az1.id
    route_table_id = aws_route_table.private_az1.id
}
