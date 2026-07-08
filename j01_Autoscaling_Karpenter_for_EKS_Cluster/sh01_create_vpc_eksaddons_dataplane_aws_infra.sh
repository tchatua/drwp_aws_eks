#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo "STEP1: Creating VPC using Terraform"
echo "----------------------------------"

cd i01_External_DNS/b04_VPC_Module/

terraform init
terraform apply -auto-approve


echo "------------------------------------------"
echo "STEP1: Creating EKS Cluster using Terraform"
echo "------------------------------------------"

cd ../b05_EKS_Cluster_Addons_ExternalDNS || { echo "ERROR: VPC module directory not found"; exit 1; }

terraform init
terraform apply -auto-approve


echo "------------------------------------------"
echo "STEP1: Creating dataplane using Terraform"
echo "------------------------------------------"

cd ../../i02_External_dns_Ingress_ssl_retail_store/f02_aws_dataplane_terraform_deployment || { echo "ERROR: EKS module directory not found"; exit 1; }

terraform init
terraform apply -auto-approve


echo "-------------------------------------------"
echo "All Terraform steps completed successfully!"
echo "-------------------------------------------"
