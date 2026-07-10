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

## HELM Provider
provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
