output "aws_vpc_id" {
  value       = module.vpc.aws_vpc_id
  description = "ID of the main VPC created for the project."
}

output "aws_public_subnet_ids" {
  value       = module.vpc.aws_public_subnet_ids
  description = "IDs of the public subnets created for the project."
}

output "aws_private_subnet_ids" {
  value       = module.vpc.aws_private_subnet_ids
  description = "IDs of the private subnets created for the project."
}

output "aws_public_subnet_map" {
  value       = module.vpc.aws_public_subnet_map
  description = "Map of public subnet IDs to their CIDR blocks."
}

output "aws_az_subnet_id_map" {
  value       = module.vpc.aws_az_subnet_id_map
  description = "Map of availability zone to Public subnet ID."
}
