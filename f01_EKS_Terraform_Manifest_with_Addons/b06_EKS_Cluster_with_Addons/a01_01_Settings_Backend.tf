/*
  Terraform Settings Block
  ------------------------
  - Enforces a minimum Terraform version to ensure consistent behavior across
    environments and prevent compatibility issues.
  - Declares required providers and their versions to guarantee deterministic
    builds and reproducible infrastructure deployments.
  - Configures the remote backend (S3 + DynamoDB) used to securely store and
    lock Terraform state across environments.
*/

terraform {
  required_version = ">= 1.15.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Ensures compatibility with AWS provider v6.x
    }
  }
  /*
  Remote Backend Configuration (S3 + DynamoDB)
  --------------------------------------------
  - Stores the Terraform state file remotely in an S3 bucket to enable
    centralized, versioned, and secure state management across environments.
  - Uses a DynamoDB table to provide state locking, preventing concurrent
    Terraform operations that could corrupt the state.
  - Encryption is enabled to protect sensitive information stored in the
    state file.
  - The backend configuration must be initialized before Terraform can
    manage any resources in this environment.
*/

  backend "s3" {
    bucket         = "tfstate-dev-terraformprojects-n5ov6p" # S3 bucket where the remote state file is stored
    key            = "eks/dev/terraform.tfstate"            # Path inside the bucket for this environment's state file
    region         = "us-east-2"                            # AWS region where the bucket and DynamoDB table reside
    dynamodb_table = "tfstate-lock-dev-terraformprojects"   # DynamoDB table used for state locking
    encrypt        = true                                   # Enables (server‑side encryption)SSE-S3 encryption for the state file
    # use_lockfile   = true                                    # Enables Terraform-native lockfile-based state locking
  }
}
