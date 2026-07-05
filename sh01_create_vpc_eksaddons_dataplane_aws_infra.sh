#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo "STEP1: Creating VPC using Terraform"
echo "----------------------------------"

cd f01_EKS_Terraform_Manifest_with_Addons/b04_VPC_Module

terraform init
terraform apply -auto-approve


echo "------------------------------------------"
echo "STEP1: Creating EKS Cluster using Terraform"
echo "------------------------------------------"

cd ../b06_EKS_Cluster_with_Addons || { echo "ERROR: VPC module directory not found"; exit 1; }

terraform init
terraform apply -auto-approve


echo "------------------------------------------"
echo "STEP1: Creating dataplane using Terraform"
echo "------------------------------------------"

cd ../../f02_aws_dataplane_terraform_deployment/ || { echo "ERROR: EKS module directory not found"; exit 1; }

terraform init
terraform apply -auto-approve


echo "-------------------------------------------"
echo "All Terraform steps completed successfully!"
echo "-------------------------------------------"


