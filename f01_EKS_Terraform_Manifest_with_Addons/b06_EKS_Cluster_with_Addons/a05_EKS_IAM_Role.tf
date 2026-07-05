/*
  IAM Role for the EKS Control Plane
  ----------------------------------
  This IAM role is assumed by the EKS service (eks.amazonaws.com) so the
  Kubernetes control plane can interact with AWS resources inside my account.

  Why this role is required:
    - The EKS control plane runs in an AWS‑owned account, not in my VPC.
    - To manage cluster resources (ENIs, load balancers, networking, etc.),
      the control plane must assume an IAM role in my account.
    - This trust policy ensures ONLY the EKS service can assume this role.

  Key Components:
    • name
        Uses the local.name_prefix to maintain consistent naming across environments.

    • assume_role_policy
        Defines the trust relationship. The jsonencode() function converts the
        Terraform map into valid JSON for AWS IAM.

    • tags
        Optional metadata for tracking, cost allocation, or governance.
*/

resource "aws_iam_role" "eks_cluster" {
  name = "${local.name_prefix}-eks-cluster-role"

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
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}
# ----------------------------------------------------------------------------------
/*
  Attach the AmazonEKSClusterPolicy to the EKS Control Plane IAM Role
  -------------------------------------------------------------------
  This policy attachment grants the EKS control plane the core permissions
  required to operate the cluster. Without this policy, the control plane
  cannot perform essential actions such as:

    • Managing cluster lifecycle operations
    • Interacting with networking components
    • Registering worker nodes
    • Creating and managing control plane–related AWS resources

  Key Components:
    • role
        References the IAM role created for the EKS control plane
        (aws_iam_role.eks_cluster).

    • policy_arn
        AWS-managed policy: AmazonEKSClusterPolicy
        This is a mandatory policy for every EKS cluster.
*/
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
# ----------------------------------------------------------------------------------
/*
  Attach the AmazonEKS_VPCResourceController Policy
  -------------------------------------------------
  This policy attachment grants the EKS control plane the permissions required
  to manage advanced VPC networking components inside my AWS account.

  Why this policy matters:
    • Enables the EKS control plane to manage ENIs (Elastic Network Interfaces)
    • Required for IP address management and enhanced networking
    • Needed for features like:
        - EKS Fargate profiles
        - Karpenter node provisioning
        - VPC CNI advanced modes
    • Recommended by AWS for production-grade clusters

  Key Components:
    • role
        References the IAM role created for the EKS control plane
        (aws_iam_role.eks_cluster).

    • policy_arn
        AWS-managed policy: AmazonEKSVPCResourceController
        Provides networking‑related permissions beyond the base cluster policy.
*/ resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

