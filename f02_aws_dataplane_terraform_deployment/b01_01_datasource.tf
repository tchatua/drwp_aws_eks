# Data Source: AWS Account Info
data "aws_caller_identity" "current" {}

# Data Source: AWS Region
data "aws_region" "current" {}

