###########################################
# External DNS IAM Role (for Pod Identity)
###########################################
resource "aws_iam_role" "external_dns_role" {
  name               = "${local.name_prefix}-external-dns-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

###########################################
# Attached AWS Managed Route53 full Access
###########################################
resource "aws_iam_role_policy_attachment" "external_dns_managed_policy" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

###########################################
# Output
###########################################
output "external_dns_role_arn" {
  value       = aws_iam_role.external_dns_role.arn
  description = "External DNS Role ARN"
}
