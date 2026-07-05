/*
  Resource: aws_s3_bucket_versioning.bucket_versioning

  Description:
    Manages versioning settings for an existing S3 bucket. This resource enables,
    suspends, or updates the versioning state of the bucket. Removing this resource
    from configuration will either suspend versioning or simply detach it from
    Terraform state if the bucket is already unversioned.

  Key Behavior:
    - Ensures the S3 bucket has versioning explicitly configured.
    - Protects against accidental overwrites or deletions by maintaining object history.
    - Uses the bucket ID from aws_s3_bucket.tfstate_bucket.

  Notes:
    - Versioning is strongly recommended for Terraform state buckets to support
      recovery, auditing, and rollback.
    - The versioning state can be "Enabled" or "Suspended".
*/

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}