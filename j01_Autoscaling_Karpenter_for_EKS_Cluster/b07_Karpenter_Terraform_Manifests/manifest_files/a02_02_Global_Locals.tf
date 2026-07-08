/*
    Local values used throughout the EKS configuration
    Helps enforce naming consistency and reduce duplication
*/

locals {
  # Business division or team name (from variable)
  owner = var.business_division

  # Environment name such as dev, staging, prod (from variable)
  environment = var.environment_name

  # Standardized naming prefix: "<division>-<env>"
  name_prefix = "${local.owner}-${local.environment}"

  # Cluster name 
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}
