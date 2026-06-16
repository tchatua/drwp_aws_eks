// Global variables
aws_region       = "us-east-2"
environment_name = "dev"
# project_name     = "drwp"

tags = {
  Terraform = "true"
  Project   = "drwp-eks"
  Owner     = "Arristide Tchatua"
  Email     = "tchattua@gmail.com"
  Demo      = "EKS with Remote Backend Demonstration - V101"
}

// EKS Cluster Variables
cluster_name                         = "drwpekscluster"
cluster_version                      = "1.34"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
cluster_endpoint_private_access      = false
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["173.61.6.206/32"] # Replace with your IP or CIDR block for secure access

// EKS Node Group Variables
node_group_desired_size = 2
node_group_max_size     = 6
node_group_min_size     = 2
node_instance_type      = ["t3.medium"] # Replace with your desired EC2 instance type(s) for the EKS node group
node_capacity_type      = "ON_DEMAND"   # or "SPOT"
node_disk_size          = 20

