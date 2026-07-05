output "tfstate_bucket_arn" {
  description = "ARN of the Terraform remote state s3 bucket"
  value       = aws_s3_bucket.tfstate_bucket.arn
}

output "tfstate_bucket_id" {
  description = "ID of the Terraform remote state s3 bucket"
  value       = aws_s3_bucket.tfstate_bucket.id
}