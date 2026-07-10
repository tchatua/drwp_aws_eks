#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo "Updating kubeconfig"
echo "----------------------------------"


# aws eks update-kubeconfig \
#   --region us-east-2 \
#   --name south-jersey-eks-tchatua-dev-eks-control-plane
# Updated context arn:aws:eks:us-east-2:088354478627:cluster/south-jersey-eks-tchatua-dev-eks-control-plane in C:\Users\tchat\.kube\config

aws eks --region us-east-2 update-kubeconfig --name south-jersey-eks-tchatua-dev-eks-control-plane

echo "----------------------------------"
echo " kubeconfig Updated"
echo "----------------------------------"
