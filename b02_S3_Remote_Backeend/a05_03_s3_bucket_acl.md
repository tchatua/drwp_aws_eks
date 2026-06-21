/*
  Resource: aws_s3_bucket_acl.bucket_acl

  Description:
    Manages the Access Control List (ACL) settings for the specified S3 bucket.
    This resource defines the bucket’s permission model and ensures that the
    access level remains consistent and explicitly controlled through Terraform.

  Key Behavior:
    - Applies the ACL defined in the `acl` argument to the target S3 bucket.
    - Ensures the bucket remains private unless intentionally changed.
    - Uses the bucket ID from aws_s3_bucket.tfstate_bucket.

  Notes:
    - Setting `acl = "private"` is the recommended security posture for
      Terraform state buckets and most production workloads.
    - ACLs are considered legacy in AWS; IAM policies and bucket policies
      are preferred for fine‑grained access control.
*/

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  acl    = "private"
}

