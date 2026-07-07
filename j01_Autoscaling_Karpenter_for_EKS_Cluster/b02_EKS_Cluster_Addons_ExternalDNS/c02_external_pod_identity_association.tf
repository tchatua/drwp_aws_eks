# ######################################
# External DNS Pod Identity Association
# ######################################
resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = aws_iam_role.external_dns_role.arn
}

# ######################################
# Output
# ######################################
output "aws_eks_pod_identity_association_id" {
  value       = aws_eks_pod_identity_association.external_dns.id
  description = "AWS EKS Pod Identity Association ID"
}