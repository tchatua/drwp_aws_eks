/*
Resource: aws_eks_node_group
Manages an EKS Node Group, which can provision and optionally update an Auto Scaling Group of Kubernetes worker nodes compatible with EKS
*/
/*
  EKS Managed Node Group
  ----------------------
  This resource provisions an EKS Managed Node Group, which creates and manages
  an Auto Scaling Group of EC2 worker nodes for the Kubernetes cluster.

  What this node group provides:
    • EC2 instances that run Kubernetes workloads (Pods)
    • Automatic scaling based on desired/min/max configuration
    • Managed lifecycle updates (rolling updates, draining, replacement)
    • Integration with EKS control plane and VPC networking

  Key Configurations:
    • cluster_name
        Associates the node group with the EKS control plane.

    • node_role_arn
        IAM role assumed by EC2 worker nodes, enabling:
          - ECR image pulls
          - VPC CNI ENI/IP management
          - Node registration with the control plane

    • subnet_ids
        Private subnets are used to ensure worker nodes are not publicly exposed.

    • instance_types / capacity_type
        Defines the EC2 instance families and whether nodes are On‑Demand or Spot.

    • scaling_config
        Controls the Auto Scaling Group size (min, max, desired).

    • update_config
        Defines rolling update behavior. Using max_unavailable_percentage ensures
        safe, controlled updates during deployments.

    • labels & tags
        Adds metadata for scheduling, organization, cost allocation, and filtering.

    • depends_on
        Ensures IAM policies are attached before node group creation. Without this,
        EKS cannot properly create or delete EC2 instances or ENIs.
*/
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_control_plane.name
  node_group_name = "${aws_eks_cluster.eks_control_plane.name}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids
  instance_types  = var.node_instance_type
  capacity_type   = var.node_capacity_type
  ami_type        = "AL2023_x86_64_STANDARD"
  disk_size       = var.node_disk_size

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    # max_unavailable = 1
    max_unavailable_percentage = 33
  }

  force_update_version = true

  labels = {
    "env" = var.environment_name
  }

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-eks-private-node-group"
    Environment = var.environment_name
  })

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
  ]
}
