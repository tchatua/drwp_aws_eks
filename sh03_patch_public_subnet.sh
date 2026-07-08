#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo        "Patch Public Subnet"
echo "----------------------------------"

cd f01_EKS_Terraform_Manifest_with_Addons/

aws ec2 create-tags \
  --resources subnet-0bb1d03938a1f994e subnet-0dd6710e32a05a7b4 subnet-075ba0cb9332658ba \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

echo "-------------------------------------------"
echo "Patch completed successfully!"
echo "-------------------------------------------"


