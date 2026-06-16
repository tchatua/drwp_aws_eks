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
