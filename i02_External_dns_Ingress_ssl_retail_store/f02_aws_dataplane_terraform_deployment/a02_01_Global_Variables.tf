# --------------------------------------------
# AWS Region used in provider block
# --------------------------------------------

# variable "aws_region" {
#   description = "The AWS region to deploy resources in"
#   type        = string
#   default     = "us-east-2"
# }

# --------------------------------------------
# Environment and business division variables
# --------------------------------------------

# Logical environment name (used in tags and resource names)
variable "environment_name" {
  description = "The name of the environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Business unit or department (used in tags and naming)
variable "business_division" {
  description = "The business division responsible for  the project"
  type        = string
  default     = "south-jersey-eks-tchatua"
}

# --------------------------------------------------------
# Common Tags
# --------------------------------------------------------

# Tags applied to all resources created by this configuration
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}
