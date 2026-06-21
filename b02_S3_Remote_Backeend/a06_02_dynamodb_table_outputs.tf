output "tfstate_lock_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.tfstate_lock.name
}

output "tfstate_lock_table_arn" {
  description = "ARN of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.tfstate_lock.arn
}
output "tfstate_lock_table_id" {
  description = "ID of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.tfstate_lock.id
}

output "tfstate_lock_table_hash_key" {
  description = "Hash key used by the DynamoDB state lock table"
  value       = aws_dynamodb_table.tfstate_lock.hash_key
}
