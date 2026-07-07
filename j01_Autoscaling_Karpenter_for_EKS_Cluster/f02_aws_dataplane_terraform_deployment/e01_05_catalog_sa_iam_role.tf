/*
    ##############################################################
    IAM Role for EKS Pod Identity (Secrets Store CSI Driver)
    -------------------------------------------------------------
    This role is assumed by the EKS Pod Identity Agent (PIA)
    on behalf of the Catalog microservice. It grants permission
    to retrieve database credentials from AWS Secrets Manager
    via the AWS Secrets & Configuration Provider (ASCP).
    ##############################################################
*/
# IAM Role for Pod Identity (for AWS Secrets Store CSI Driver)
resource "aws_iam_role" "catalog_getsecrets" {
  name               = "${local.name_prefix}-catalog-getsecrets-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-catalog-getsecrets-role"
    Environment = var.environment_name
    Component   = "AWS Secrets Store CSI Driver ASCP"
  })

}

/*
    ##############################################################
    IAM Policy Attachment
    -------------------------------------------------------------
    Attaches the Secrets Manager read‑only policy to the IAM role.
    This policy must include:
    - secretsmanager:GetSecretValue
    - secretsmanager:DescribeSecret
    for the specific secret(s) used by the Catalog microservice.
    ##############################################################
*/
# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "catalog_db_secret_attach" {
  policy_arn = aws_iam_policy.store_db_secret_policy.arn
  role       = aws_iam_role.catalog_getsecrets.name
}
/*
    ##############################################################
    Outputs
    -------------------------------------------------------------
    Exposes the IAM Role ARN so it can be referenced by:
    - Pod Identity Association
    - Helm charts
    - Kubernetes manifests
    ##############################################################
*/
# Outputs
output "catalog_sa_getsecrets_role_arn" {
  description = "IAM Role ARN for Catalog `Amazon RDS MySQL Database` Get Secrets from AWS Secrets Manager"
  value       = aws_iam_role.catalog_getsecrets.arn
}