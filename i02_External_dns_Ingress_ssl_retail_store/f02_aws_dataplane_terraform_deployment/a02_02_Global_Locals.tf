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

  # Full EKS cluster name used for resource naming and tagging
  # eks_cluster_name = "${local.name_prefix}-${var.cluster_name}"
}


