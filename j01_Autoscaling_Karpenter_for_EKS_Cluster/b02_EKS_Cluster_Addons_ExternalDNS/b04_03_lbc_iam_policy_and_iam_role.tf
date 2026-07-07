
# Resource: Create AWS Load Balancer Controller IAM Policy 
resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "${local.name_prefix}-AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy      = data.http.lbc_iam_policy.response_body
}

# Resource: Create IAM Role 
resource "aws_iam_role" "lbc_iam_role" {
  name               = "${local.name_prefix}-lbc-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${local.name_prefix}-lbc-iam-role"
    Environment = var.environment_name
    Component   = "AWS Load Balancer Controller"
  }
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role       = aws_iam_role.lbc_iam_role.name
}

