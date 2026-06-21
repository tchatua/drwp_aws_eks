/*
  Resource: aws_dynamodb_table.tfstate_lock

  Description:
    Creates a DynamoDB table used by Terraform to implement state locking
    and prevent concurrent operations. This ensures that only one Terraform
    process can modify the state at a time, protecting against corruption
    and race conditions.

  Key Behavior:
    - Uses a simple primary key named "LockID" as required by Terraform.
    - Billing mode set to PAY_PER_REQUEST for cost efficiency.
    - Strongly recommended for all remote backends using S3.

  Notes:
    - Terraform automatically writes a lock entry during `plan` and `apply`.
    - The table must exist before running `terraform init` with a remote backend.
*/

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "tfstate-lock-${var.environment_name}-${var.project_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
