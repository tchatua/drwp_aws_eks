/*
  IAM Role for EKS Managed Node Groups
  ------------------------------------
  This IAM role is assumed by EC2 instances that run as worker nodes in the
  EKS cluster. Every node in a managed node group uses this role to interact
  with AWS services on behalf of Kubernetes.

  Why this role is required:
    • Worker nodes must pull container images from ECR.
    • Nodes must register with the EKS control plane.
    • The VPC CNI plugin requires permissions to manage ENIs and IP addresses.
    • Nodes need access to CloudWatch, EBS, and other AWS services depending
      on workloads and add-ons.

  Key Components:
    • name
        Uses local.name_prefix to maintain consistent naming across environments.

    • assume_role_policy
        Trust policy allowing EC2 instances (ec2.amazonaws.com) to assume this role.
        This is required because worker nodes run on EC2.

    • tags
        Optional metadata for governance, cost allocation, and resource tracking.
*/
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.name_prefix}-eks-nodegroup-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}
# ----------------------------------------------------------------------------------
/*
  Attach the AmazonEKSWorkerNodePolicy to the EKS Node Group IAM Role
  -------------------------------------------------------------------
  This policy attachment grants worker nodes the core permissions required to
  function properly within the EKS cluster. Without this policy, worker nodes
  cannot perform essential actions such as:

    • Registering with the EKS control plane
    • Pulling container images from Amazon ECR
    • Interacting with AWS services on behalf of Kubernetes workloads

  Key Components:
    • role
        References the name of the IAM role created for node groups.

    • policy_arn
        The ARN of the managed policy that provides necessary permissions for worker nodes.
*/
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
# ----------------------------------------------------------------------------------
/*
  Attach the AmazonEKS_CNI_Policy to the EKS Node Group IAM Role
  -------------------------------------------------------------
  This policy attachment grants worker nodes the permissions required for the
  Amazon VPC CNI(Container Network Interface) plugin to manage networking for Kubernetes pods. Without this
  policy, worker nodes cannot create or manage Elastic Network Interfaces (ENIs)
  or assign IP addresses to pods, which is critical for pod-to-pod and pod-to-service
  communication within the cluster.

  Key Components:
    • role
        References the name of the IAM role created for node groups.

    • policy_arn
        The ARN of the managed policy that provides necessary permissions for the VPC CNI plugin.
*/
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

/*
  Attach the AmazonEC2ContainerRegistryReadOnly Policy to the EKS Node Group IAM Role
  -------------------------------------------------------------------------------
  This policy attachment grants worker nodes read-only access to Amazon ECR (Elastic Container Registry). 
  Without this policy, worker nodes cannot pull container images stored in ECR repositories, 
  which is essential for running Kubernetes workloads that use ECR as their image registry.

  Key Components:
    • role
        References the name of the IAM role created for node groups.

    • policy_arn
        The ARN of the managed policy that provides read-only permissions for Amazon ECR.
*/
resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

