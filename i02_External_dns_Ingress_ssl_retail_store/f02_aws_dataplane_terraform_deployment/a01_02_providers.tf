/*
  AWS Provider Configuration
  --------------------------
  - Configures the AWS provider using the region supplied via input variables.
  - The provider inherits credentials from the environment, shared config files,
    or AWS CLI unless explicitly overridden.
  - This provider block is required for all AWS resources in this module.
*/

provider "aws" {
  region = "us-east-2" #var.aws_region
}

provider "aws" {
  alias = "west2"
  region = "us-west-2"
}

/*
# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_control_plane.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_control_plane.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

## HELM Provider
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks_control_plane.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_control_plane.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token

  }
}
*/
