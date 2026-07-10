#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo        "Patch Public Subnet"
echo "----------------------------------"

# cd f01_EKS_Terraform_Manifest_with_Addons/

aws ec2 create-tags \
  --resources subnet-0c4b3fecc1d2e3a5a subnet-02634dfd14249af77 subnet-02d05e7dd6c54c8e8 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

echo "-------------------------------------------"
echo "Patch completed successfully!"
echo "-------------------------------------------"


