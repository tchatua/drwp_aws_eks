#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo        "Patch Public Subnet"
echo "----------------------------------"

cd f01_EKS_Terraform_Manifest_with_Addons/

aws ec2 create-tags \
  --resources subnet-0e6e4ea695d42f6c6 subnet-005a013bbc07741d0 subnet-07f36d4512999d9d4 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

echo "-------------------------------------------"
echo "Patch completed successfully!"
echo "-------------------------------------------"


