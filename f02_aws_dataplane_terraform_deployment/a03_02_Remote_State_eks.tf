data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tfstate-dev-terraformprojects-n5ov6p" # S3 bucket where the remote state file is stored
    key    = "eks/dev2/terraform.tfstate"           # Path inside the bucket for this environment's state file
    region = "us-east-2"                            # AWS region where the bucket and DynamoDB table reside
    # dynamodb_table = "tfstate-lock-dev-terraformprojects"       # DynamoDB table}

  }
}

# Output the VPC ID from the remote state to use in this module
output "eks_cluster_name" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

output "eks_cluster_id" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

output "eks_cluster_security_group_id" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id
}

