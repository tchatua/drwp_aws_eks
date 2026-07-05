/*
Resource: aws_s3_bucket_public_access_block
    Manages S3 bucket-level Public Access Block configuration. 
*/

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}