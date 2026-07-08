data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "tfstate-dev-terraformprojects-n5ov6p" # S3 bucket where the remote state file is stored
    key            = "vpc/dev2/terraform.tfstate"           # Path inside the bucket for this environment's state file
    region         = "us-east-2"                            # AWS region where the bucket and DynamoDB table reside
    # dynamodb_table = "tfstate-lock-dev-terraformprojects"   # DynamoDB table}
  }
}

# Output the VPC ID from the remote state to use in this module
output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.aws_vpc_id
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.aws_public_subnet_ids
}

output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids
}
