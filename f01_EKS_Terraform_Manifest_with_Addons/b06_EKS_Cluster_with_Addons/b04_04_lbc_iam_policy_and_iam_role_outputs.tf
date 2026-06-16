
output "lbc_iam_policy_arn" {
  value = aws_iam_policy.lbc_iam_policy.arn 
}


output "lbc_iam_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"
  value = aws_iam_role.lbc_iam_role.arn
}
