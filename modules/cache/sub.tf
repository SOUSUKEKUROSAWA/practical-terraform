resource "aws_elasticache_parameter_group" "this" {
    name = var.name
    family = "${var.engine}${var.engine_version}"

    dynamic "parameter" {
        for_each = var.parameters

        content {
            name = parameter.key
            value = parameter.value
        }
    }
}

resource "aws_elasticache_subnet_group" "this" {
    name = var.name
    subnet_ids = var.private_subnet_ids
}

module "cache_sg" {
    source = "../network/secutiry-group"
    name = var.name
    vpc_id = var.vpc_id
    port = var.port
    cidr_blocks = [var.vpc_cidr_block]
}
