
/*
===============================================================================
Terraform Settings
===============================================================================

Purpose:
- Enforces a minimum Terraform version to ensure consistent behavior across
  environments and prevent version compatibility issues.
- Defines the required providers along with version constraints to guarantee
  deterministic builds and reproducible infrastructure deployments.
- Configures a remote backend for centralized Terraform state management.

===============================================================================
*/

terraform {
  # Minimum Terraform CLI version required
  required_version = ">= 1.15.5"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Ensures compatibility with AWS provider v6.x
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
    # Optional HTTP Provider
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }

  /*
  ---------------------------------------------------------------------------
  Remote Backend Configuration (Amazon S3)
  ---------------------------------------------------------------------------
  Purpose:
  - Stores the Terraform state file remotely in an Amazon S3 bucket.
  - Provides centralized, secure, and versionable state management.
  - Enables collaboration across multiple users and environments.
  - Uses Terraform-native lockfile-based state locking to prevent
    concurrent operations from corrupting the state file.
  - Encrypts the state file at rest using server-side encryption (SSE-S3).

  Note:
  - The backend must be initialized using `terraform init`
    before Terraform can manage any infrastructure resources.
  ---------------------------------------------------------------------------
  */

  backend "s3" {
    bucket       = "tfstate-dev-terraformprojects-n5ov6p" # S3 bucket where the remote state file is stored
    key          = "karpenter/dev2/terraform.tfstate"     # Path inside the bucket for this environment's state file
    region       = "us-east-2"                            # AWS region where the bucket and DynamoDB table reside
    encrypt      = true                                   # Enables (server‑side encryption)SSE-S3 encryption for the state file
    use_lockfile = true                                   # Enables Terraform-native lockfile-based state locking
  }
}
