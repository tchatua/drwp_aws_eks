/*
Data Source: aws_iam_policy_document
    Generates an IAM policy document in JSON format for use with resources that expect policy documents such as aws_iam_policy.

    Using this data source to generate policy documents is optional. 
    It is also valid to use literal JSON strings in your configuration 
    or to use the file interpolation function to read a raw JSON policy document from a file.
*/

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

