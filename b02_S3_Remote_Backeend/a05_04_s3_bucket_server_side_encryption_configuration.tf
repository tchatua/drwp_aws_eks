/*
Resource: aws_s3_bucket_server_side_encryption_configuration
    Provides a S3 bucket server-side encryption configuration resource.
*/

/*
  Resource: aws_s3_bucket_server_side_encryption_configuration.tfstate_encryption

  Description:
    Enforces default server-side encryption (SSE) on the S3 bucket used for
    storing Terraform state. This ensures that all objects uploaded to the
    bucket are encrypted at rest, even when clients do not explicitly request
    encryption.

  Key Behavior:
    - Applies a default encryption rule to the target S3 bucket.
    - Uses the AES256 algorithm (SSE-S3), AWS’s managed encryption option.
    - Ensures all new objects are automatically encrypted upon upload.

  Notes:
    - Strongly recommended for Terraform state buckets to protect sensitive
      metadata and maintain compliance.
    - Supports alternative algorithms such as aws:kms if KMS-managed keys
      are required for stricter security controls.
*/

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

