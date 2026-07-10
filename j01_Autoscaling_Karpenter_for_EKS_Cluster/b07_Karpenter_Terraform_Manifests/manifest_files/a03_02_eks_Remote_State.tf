data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tfstate-dev-terraformprojects-n5ov6p" # S3 bucket where the remote state file is stored
    key    = "eks/dev2/terraform.tfstate"           # Path inside the bucket for this environment's state file
    region = "us-east-2"                            # AWS region where the bucket and DynamoDB table reside
  }
}

# Output the EKS eks_cluster_name and eks_cluster_id from the remote EKS state
output "eks_cluster_name" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

output "eks_cluster_id" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_id
}
