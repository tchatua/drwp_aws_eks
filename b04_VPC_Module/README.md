# VPC Project using Terraform

## AWS VPC Architecture

- Provisions a custom VPC with user-defined CIDR block
- Public & private subnets across up to 3 Availability Zones
- Creates a single NAT Gateway for private subnets (cost-effective)
- Manages route tables and subnet associations
- Exports clean outputs to integrate with EC2, RDS, EKS etc.

![alt text](image.png)
