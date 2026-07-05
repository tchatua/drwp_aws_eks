variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "environment_name" {
  description = "The name of the environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "terraformprojects"

}

variable "tags" {
  description = "Global tags to apply to all   resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Purpose   = "terraform backend"
  }
}

