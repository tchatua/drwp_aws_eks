#!/bin/bash

set -e  # Exit immediately if any command fails

echo "------------------------------------------"
echo "STEP1: Deleting EKS Cluster using Terraform"
echo "------------------------------------------"

cd b05_EKS_Cluster/ || { echo "ERROR: EKS module directory not found"; exit 1; }

terraform init
terraform apply -destroy -auto-approve



echo "----------------------------------"
echo "STEP1: Deleting VPC using Terraform"
echo "----------------------------------"

cd ../b04_VPC_Module/ || { echo "ERROR: VPC module directory not found"; exit 1; }

terraform init
terraform apply -destroy -auto-approve

echo "-------------------------------------------"
echo "All Terraform steps completed successfully!"
echo "-------------------------------------------"

cd ..
