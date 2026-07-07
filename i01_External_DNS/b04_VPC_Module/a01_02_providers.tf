/*
  AWS Provider Configuration
  --------------------------
  - Configures the AWS provider using the region supplied via input variables.
  - The provider inherits credentials from the environment, shared config files,
    or AWS CLI unless explicitly overridden.
  - This provider block is required for all AWS resources in this module.
*/

provider "aws" {
  region = var.aws_region
}

