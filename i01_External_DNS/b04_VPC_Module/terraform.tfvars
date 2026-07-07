// Global variables
aws_region       = "us-east-2"
environment_name = "qa"
project_name     = "drwp"

tags = {
  Terraform = "true"
  Project   = "drwp-eks"
  Owner     = "Arristide Tchatua"
  Email     = "tchattua@gmail.com"
  Demo      = "VPC with Remote Backend Demonstration - V101"
}

// VPC Variables
vpc_cidr_block            = "192.168.0.0/16"
subnet_newbits_cidr_block = 8


