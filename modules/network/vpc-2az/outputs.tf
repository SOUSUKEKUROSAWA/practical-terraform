output "vpc_id" {
    value = aws_vpc.this.id
}

output "public_subnet_ids" {
    value = [
        aws_subnet.public_az0.id,
        aws_subnet.public_az1.id
    ]
}

output "private_subnet_ids" {
    value = [
        aws_subnet.private_az0.id,
        aws_subnet.private_az1.id
    ]
}
