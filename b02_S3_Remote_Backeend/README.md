# Terraform Remote Backend Setup on AWS (S3)

This Terraform project provisions the necessary AWS infrastructure to enable remote state management using Amazon S3.
- Remote backends allow teams to securely share and lock Terraform state files, a critical requirement for collaboration and consistency in DevOps workflows.

## Why Use Remote Backend?

- Team Collaboration: Prevent state conflicts when multiple people run Terraform.
- State Locking: Avoids race conditions using DynamoDB.
- Durability: S3 ensures highly available and persistent state storage.
- After setting up the backend infrastructure, I can safely use it in my main Terraform configurations for provisioning VPCs, EKS clusters, etc.

## Creates an S3 Bucket to store Terraform state files.

- Supports parameterization using input variables for environment-specific deployments.




