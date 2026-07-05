/*
  random_string (Resource)

  The `random_string` resource generates a cryptographically secure,
  random sequence of characters. It is commonly used to create unique
  suffixes for AWS resources such as S3 buckets, IAM roles, VPC names,
  and other identifiers that require global uniqueness.

  Configuration Details:
    - `length = 6`
         Produces a string exactly 6 characters long.

    - `special = false`
         Excludes all special characters from the generated string.

    - `upper = false`
         Ensures the output contains no uppercase letters (A–Z).

    - `override_special`
         Optional. When `special = true`, this attribute allows you to
         define a custom set of allowed special characters.
*/
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

