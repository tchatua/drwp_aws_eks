variable "environment_name" {
  description = "The name of the environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "tchatua-eks-project"
  # a04_Udemy/a13_Ultimate_DevOps_Real_World_Project_on_AWS_Cloud/drwp_aws_eks/a02_VPC

}


variable "tags" {
  description = "Global tags to apply to all   resources"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}
