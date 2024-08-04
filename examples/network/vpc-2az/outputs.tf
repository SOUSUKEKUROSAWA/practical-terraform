output "vpc_id" {
    value = module.example.vpc_id
}

output "public_subnets_ids" {
    value = module.example.public_subnets_ids
}

output "private_subnets_ids" {
    value = module.example.private_subnets_ids
}
