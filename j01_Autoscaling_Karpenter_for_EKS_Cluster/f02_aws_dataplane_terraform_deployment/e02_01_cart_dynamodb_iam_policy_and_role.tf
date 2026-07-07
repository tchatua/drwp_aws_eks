/*
    ##############################################################
    IAM Policy for DynamoDB Access (Cart microservice)
    -------------------------------------------------------------
    Grants the Cart microservice full DynamoDB access. This is
    appropriate for development or internal microservices that
    own their table lifecycle (CRUD on tables + items).

    In production, consider scoping Resource to the specific
    table ARN(s) instead of "*", unless the service legitimately
    manages multiple tables dynamically.
    ##############################################################
*/
# IAM Policy for DynamoDB Access (Cart microservice) - Full Access
resource "aws_iam_policy" "cart_dynamodb_policy" {
  name        = "${local.name_prefix}-cart-dynamodb-policy"
  description = "Allow Cart microservice full access to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTables",
          "dynamodb:ListTagsOfResource"
        ]
        Resource = "*" # Full access to all DynamoDB resources in all regions
      }
    ]
  })
}

/*
    ##############################################################
    IAM Role for Cart microservice (EKS Pod Identity)
    -------------------------------------------------------------
    This role is assumed by the EKS Pod Identity Agent (PIA)
    on behalf of the Cart microservice. It provides the
    permissions defined in the DynamoDB policy above.
    ##############################################################
*/
# IAM Role for Cart microservice (Pod Identity Role)
resource "aws_iam_role" "cart_dynamodb_role" {
  name               = "${local.name_prefix}-cart-dynamodb-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-cart-dynamodb-role"
    Environment = var.environment_name
    Component   = "Cart"
  })
}
/*
    ##############################################################
    IAM Policy Attachment
    -------------------------------------------------------------
    Attaches the DynamoDB access policy to the Cart Pod Identity
    IAM role.
    ##############################################################
*/
# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "cart_dynamodb_policy_attach" {
  policy_arn = aws_iam_policy.cart_dynamodb_policy.arn
  role       = aws_iam_role.cart_dynamodb_role.name
}


# Outputs
output "cart_dynamodb_policy_arn" {
  description = "IAM Policy ARN for Cart microservice DynamoDB access"
  value       = aws_iam_policy.cart_dynamodb_policy.arn
}

output "cart_dynamodb_role_arn" {
  description = "IAM Role ARN for Cart microservice Pod Identity"
  value       = aws_iam_role.cart_dynamodb_role.arn
}
