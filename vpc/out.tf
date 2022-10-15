output "prod_main_vpc_id" {
  value = aws_vpc.main.id
}

output "prod_main_public_subnets_ids" {
  value = values(aws_subnet.public_subnets)[*].id
}


output "prod_main_private_subnets_ids" {
  value = values(aws_subnet.private_subnets)[*].id
}

