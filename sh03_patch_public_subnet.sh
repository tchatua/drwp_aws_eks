#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo        "Patch Public Subnet"
echo "----------------------------------"

cd f01_EKS_Terraform_Manifest_with_Addons/

aws ec2 create-tags \
  --resources subnet-087aef4de3fd97be1 subnet-0525fe1bbd043d674 subnet-04a77ed3f0a66e224 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-eks-control-plane,Value=shared

echo "-------------------------------------------"
echo "Patch completed successfully!"
echo "-------------------------------------------"
