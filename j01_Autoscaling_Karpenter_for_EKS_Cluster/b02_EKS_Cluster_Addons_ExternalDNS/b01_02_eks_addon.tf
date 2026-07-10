/*
Resource: aws_eks_addon

Manages an EKS add-on.
*/

resource "aws_eks_addon" "pod_identity" {
  depends_on                  = [aws_eks_node_group.eks_node_group]
  cluster_name                = aws_eks_cluster.eks_control_plane.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  addon_version               = data.aws_eks_addon_version.pia_latest.version # latest verion

}

