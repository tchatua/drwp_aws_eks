output "aws_vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the main VPC created for the project."
}

output "aws_public_subnet_ids" {
  value       = [for subnet in aws_subnet.public : subnet.id]
  description = "IDs of the public subnets created for the project."
}

output "aws_private_subnet_ids" {
  value       = [for subnet in aws_subnet.private : subnet.id]
  description = "IDs of the private subnets created for the project."
}

output "aws_public_subnet_map" {
  value       = { for subnet in aws_subnet.public : subnet.id => subnet.cidr_block }
  description = "Map of public subnet IDs to their CIDR blocks."
}

output "aws_az_subnet_id_map" {
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
  description = "Map of availability zone to Public subnet ID."
}
