/*
Data Source: aws_eks_addon_version -> To get default EKS addon version compatible with EKS cluster version
    Retrieve information about a specific EKS add-on version compatible with an EKS cluster version.



*/

data "aws_eks_addon_version" "pia_default" {
  addon_name         = "${local.name_prefix}-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.eks_control_plane.version
}

# ----------------------------------------------------------------------------
/*
Data Source: aws_eks_addon_version -> To get LATEST EKS addon version compatible with EKS cluster version
*/

data "aws_eks_addon_version" "pia_latest" {
  addon_name         = "${local.name_prefix}-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.eks_control_plane.version
  most_recent = true
}
