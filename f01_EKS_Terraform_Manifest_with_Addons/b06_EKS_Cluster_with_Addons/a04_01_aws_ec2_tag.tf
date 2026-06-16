/*
----------------------------------------------------------------------------------
    AWS EKS Public Subnet Tag for Public Load Balancers
----------------------------------------------------------------------------------
  This Terraform block applies the required EKS subnet tag to every public subnet
  so AWS can create internet‑facing load balancers for Kubernetes Services of type
  "LoadBalancer".

  for_each = toset(data.terraform_remote_state.vpc.outputs.aws_public_subnet_ids)
    - Retrieves all public subnet IDs from the VPC remote state.
    - Converts the list into a set for iteration.
    - Creates one tag resource per subnet (e.g., 3 subnets → 3 tags).
    - Eliminates the need to duplicate this block manually.

  resource_id = each.value
    - During iteration, each.value represents the current subnet ID.
    - Terraform attaches the tag to each subnet individually:
        subnet‑1
        subnet‑2
        subnet‑3
      All public subnets receive the tag automatically.

  key = "kubernetes.io/role/elb"
    - This is a required AWS/EKS tag.
    - It signals that the subnet is eligible for **internet‑facing** load balancers.
    - Used by:
        • Kubernetes Services of type LoadBalancer
        • AWS Classic Load Balancers (CLB)
        • AWS Network Load Balancers (NLB)

  value = "1"
    - AWS expects the value "1" to enable this role.
    - Indicates that the subnet is active for public load balancer placement.
*/
resource "aws_ec2_tag" "eks_subnet_tag_public_elb" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.aws_public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}
# ---------------------------------------------------------------------------------- 
/*
  This Terraform block applies the required EKS cluster‑association tag to every
  public subnet. EKS uses this tag to identify which subnets belong to the cluster
  and are eligible for provisioning load balancers and other managed resources.

  for_each = toset(data.terraform_remote_state.vpc.outputs.aws_public_subnet_ids)
    - Retrieves all public subnet IDs from the VPC remote state.
    - Converts the list into a set for deterministic iteration.
    - Creates one tag resource per subnet (e.g., 3 subnets → 3 tags).
    - Ensures consistent tagging without duplicating code.

  resource_id = each.value
    - During iteration, each.value represents the current subnet ID.
    - Terraform attaches the cluster‑association tag to each subnet individually.

  key = "kubernetes.io/cluster/${local.eks_cluster_name}"
    - Required AWS/EKS tag that links the subnet to the EKS cluster.
    - Enables the cluster to use these subnets for provisioning:
        • Load balancers
        • ENIs (Elastic Network Interfaces)
        • Other EKS-managed networking components
    - Uses the computed local.eks_cluster_name to maintain consistent naming.

  value = "shared"
    - Indicates that the subnet can be shared by multiple EKS clusters if needed.
    - This is the AWS‑recommended value for cluster‑associated subnets.
*/
resource "aws_ec2_tag" "eks_subnet_tag_public_cluster" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.aws_public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value       = "shared"
}
# ----------------------------------------------------------------------------------
/*
  This Terraform block applies the required EKS internal load balancer tag to every
  private subnet. EKS uses this tag to determine which subnets should host
  **internal‑only** load balancers for Kubernetes Services of type LoadBalancer
  that are not exposed to the public internet.

  for_each = toset(data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids)
    - Retrieves all private subnet IDs from the VPC remote state.
    - Converts the list into a set for deterministic iteration.
    - Creates one tag resource per private subnet (e.g., 3 subnets → 3 tags).
    - Ensures consistent tagging without duplicating code.

  resource_id = each.value
    - During iteration, each.value represents the current private subnet ID.
    - Terraform attaches the internal‑ELB tag to each subnet individually.

  key = "kubernetes.io/role/internal-elb"
    - Required AWS/EKS tag for internal load balancer placement.
    - Instructs EKS to use these subnets **only** for internal-facing load balancers.
    - Ensures that private workloads remain isolated from public internet exposure.

  value = "1"
    - AWS expects the value "1" to enable this role.
    - Indicates that the subnet is active for internal load balancer provisioning.
*/
# ----------------------------------------------------------------------------------
resource "aws_ec2_tag" "eks_subnet_tag_private_elb" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
# ----------------------------------------------------------------------------------
/*
  This Terraform block applies the required EKS cluster‑association tag to every
  private subnet. EKS uses this tag to identify which subnets belong to the cluster
  and are eligible for provisioning load balancers and other managed resources.

  for_each = toset(data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids)
    - Retrieves all private subnet IDs from the VPC remote state.
    - Converts the list into a set for deterministic iteration.
    - Creates one tag resource per subnet (e.g., 3 subnets → 3 tags).
    - Ensures consistent tagging without duplicating code.

  resource_id = each.value
    - During iteration, each.value represents the current private subnet ID.
    - Terraform attaches the cluster‑association tag to each subnet individually.

  key = "kubernetes.io/cluster/${local.eks_cluster_name}"
    - Required AWS/EKS tag that links the subnet to the EKS cluster.
    - Enables the cluster to use these subnets for provisioning:
        • Load balancers
        • ENIs (Elastic Network Interfaces)
        • Other EKS-managed networking components
    - Uses the computed local.eks_cluster_name to maintain consistent naming.

  value = "shared"
    - Indicates that the subnet can be shared by multiple EKS clusters if needed.
    - This is the AWS‑recommended value for cluster‑associated subnets.
*/
resource "aws_ec2_tag" "eks_subnet_tag_private_cluster" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value       = "shared"
}
