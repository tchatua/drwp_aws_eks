output "pod_identity_agent_eks_addon_default_version" {
  value = data.aws_eks_addon_version.pia_default
}

output "pod_identity_agent_eks_addon_latest_version" {
  value = data.aws_eks_addon_version.pia_latest
}

output "pod_identity_agent_eks_addon_arn" {
  value = aws_eks_addon.pod_identity.arn
}


output "pod_identity_agent_eks_addon_id" {
  value = aws_eks_addon.pod_identity.id
}
