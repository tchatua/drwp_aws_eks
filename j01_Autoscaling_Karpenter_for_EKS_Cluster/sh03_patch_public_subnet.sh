#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo        "Patch Public Subnet"
echo "----------------------------------"

cd b02_EKS_Cluster_Addons_ExternalDNS/

aws ec2 create-tags \
  --resources subnet-080626882ac1d253e subnet-04c5112d45ba3a45d subnet-0fd0443af9ac6f311 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/eks-control-plane,Value=owned

echo "-------------------------------------------"
echo "Patch completed successfully!"
echo "-------------------------------------------"


echo "----------------------------------"
echo        "Patch Private Subnet"
echo "----------------------------------"

#  Remove the old tag
aws ec2 delete-tags \
  --resources subnet-0739442a734c80426 subnet-0a045721ae0be0436 subnet-037489b0725fabe93 \
  --tags Key=kubernetes.io/cluster/south-jersey-eks-tchatua-dev-drwpekscluster \
  --region us-east-2

# Add the new tag
aws ec2 create-tags \
  --resources subnet-0739442a734c80426 subnet-0a045721ae0be0436 subnet-037489b0725fabe93 \
  --tags Key=kubernetes.io/cluster/eks-control-plane,Value=owned \
  --region us-east-2

# Also verify the security group tag
aws ec2 describe-security-groups \
  --group-ids sg-0896cc29e97573ea2 \
  --region us-east-2
