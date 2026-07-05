resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tfstate-${var.environment_name}-${var.project_name}-${random_string.suffix.result}"
  lifecycle {
    prevent_destroy = false
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-tfstate-bucket"
  })
}