output "eks_cluster_endpoint" {
  description = "The endpoint URL of the EKS API cluster's control plane"
  value       = aws_eks_cluster.eks_control_plane.endpoint
}

output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.id
}

output "eks_cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.version
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.name
}

output "eks_cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.certificate_authority[0].data
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.arn
}

output "eks_cluster_status" {
  description = "The current status of the EKS cluster (e.g., ACTIVE, CREATING, DELETING)"
  value       = aws_eks_cluster.eks_control_plane.status
}

output "eks_cluster_security_group_id" {
  description = "The ID of the security group associated with the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.vpc_config[0].cluster_security_group_id
}

output "private_node_group_name" {
  description = "Name of the EKS private node group"
  value       = aws_eks_node_group.eks_node_group.node_group_name
}

output "eks_node_instance_role_arn" {
  description = "IAM Role ARN used by EKS node group (EC2 worker nodes)"
  value       = aws_iam_role.eks_nodegroup_role.arn
}

output "to_configure_kubectl_command" {
  description = "The command to update local kubeconfig to connect to the EKS cluster"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.eks_control_plane.name}"
}

