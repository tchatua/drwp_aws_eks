/*
===============================================================================
Karpenter Controller IAM Trust Policy
===============================================================================
Purpose:
- Defines the trust relationship required for EKS Pod Identity.
- Allows the Karpenter controller pod to assume an IAM role.
- Enables secure access to AWS APIs without storing long-lived credentials
  inside Kubernetes pods.

Trusted Principal:
- pods.eks.amazonaws.com

Allowed Actions:
- sts:AssumeRole
- sts:TagSession

===============================================================================
*/

data "aws_iam_policy_document" "karpenter_controller_assume" {
  statement {
    sid = "PodIdentity"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  name               = "${local.name_prefix}-karpenter-controller-role"
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume.json
  tags               = var.tags
}

# Karpenter Controller IAM Role Outputs
output "karpenter_controller_role_name" {
  description = "IAM role name used by the Karpenter controller"
  value       = aws_iam_role.karpenter_controller.name
}

output "karpenter_controller_role_arn" {
  description = "IAM role ARN for the Karpenter controller"
  value       = aws_iam_role.karpenter_controller.arn
}