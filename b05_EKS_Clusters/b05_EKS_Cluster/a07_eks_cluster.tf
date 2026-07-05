/*
  Create the Amazon EKS Cluster (Control Plane)
  ---------------------------------------------
  This resource provisions the EKS control plane — the managed Kubernetes master
  components provided by AWS. The control plane runs in an AWS‑owned VPC, while
  worker nodes and cluster networking live in the customer VPC.

  Key Responsibilities of the Control Plane:
    • Runs the Kubernetes API server, scheduler, controller manager, and etcd
    • Manages cluster state and orchestrates workloads
    • Interacts with AWS resources using the IAM role defined earlier

  This block configures:
    • Cluster name and Kubernetes version
    • IAM role for control plane permissions
    • VPC networking (private/public endpoint access, subnet selection)
    • Kubernetes service CIDR
    • Control plane logging
    • Access configuration for authentication
    • Dependency ordering to ensure IAM policies exist before cluster creation
*/

resource "aws_eks_cluster" "eks_control_plane" {
  name     = "${local.name_prefix}-eks-control-plane"
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  # Configure how the control plane connects to the VPC
  vpc_config {
    subnet_ids                   = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids
    endpoint_private_access      = var.cluster_endpoint_private_access
    endpoint_public_access       = var.cluster_endpoint_public_access
    # endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  # Configure Kubernetes networking (service CIDR)
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable control plane logs for observability and auditing
  enabled_cluster_log_types = [
    "api",               # API server logs
    "audit",             # Detailed audit logs for compliance and security
    "authenticator",     # Authentication events
    "controllerManager", # Control plane controller operations
    "scheduler"          # Pod scheduling decisions
  ]

  # Ensure IAM policies are attached before cluster creation.
  # Without this, EKS cannot create or clean up managed infrastructure.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]

  # Configure how users authenticate to the cluster
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    # Options:
    #   API               → IAM-based access only
    #   CONFIG_MAP        → aws-auth ConfigMap only
    #   API_AND_CONFIG_MAP → Recommended hybrid mode

    bootstrap_cluster_creator_admin_permissions = true
    # Grants the creator admin access via aws-auth ConfigMap
  }
}
