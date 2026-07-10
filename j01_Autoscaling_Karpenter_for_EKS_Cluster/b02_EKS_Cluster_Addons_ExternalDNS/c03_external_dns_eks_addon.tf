# ############################################
# Discover Latest External DNS Addon Version
# ############################################

data "aws_eks_addon_version" "external_dns_latest" {
  addon_name         = "external-dns"
  kubernetes_version = aws_eks_cluster.eks_control_plane.version
  most_recent        = true
}

# ############################################
# Install External Add-on
# ############################################
# Install the ExternalDNS Amazon EKS Add-on
# ExternalDNS automatically manages DNS records in Route 53
# based on Kubernetes Ingresses and Services.

resource "aws_eks_addon" "external_dns" {
  depends_on = [
    aws_iam_role.external_dns_role,
    aws_eks_pod_identity_association.external_dns,
    aws_eks_addon.pod_identity,
    aws_eks_node_group.eks_node_group
  ]
  cluster_name  = aws_eks_cluster.eks_control_plane.name
  addon_name    = "external-dns"
  addon_version = data.aws_eks_addon_version.external_dns_latest.version

  # Overwrite any existing configuration conflicts during
  # initial installation or future updates.
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  service_account_role_arn = aws_iam_role.external_dns_role.arn

  tags = {
    component = "ExternalDNS"
    ManagedBy = "Terraform"
    Project   = local.name_prefix
  }
}

##############################################
# Outputs
##############################################
output "external_dns_addon_version" {
  value = aws_eks_addon.external_dns.addon_version
}

output "external_dns_addon_arn" {
  value = aws_eks_addon.external_dns.arn
}

output "externaldns_addon_id" {
  value = aws_eks_addon.external_dns.id
}