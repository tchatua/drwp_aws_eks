# My EC2NodeClass is looking for:

Subnet Selector Terms:
  Tags:
    kubernetes.io/cluster/eks-control-plane: owned
    kubernetes.io/role/internal-elb: "1"

# Verify the EKS cluster name
aws eks list-clusters --region us-east-2
kubectl config current-context

# Verify Current AWS Region
aws configure get region

# Query the Correct Region
aws ec2 describe-subnets \
  --region us-east-2 \
  --output table

## Or temporarily set: (For Git Bash)
export AWS_DEFAULT_REGION=us-east-2

### Retry:
aws ec2 describe-subnets \
  --filters "Name=tag:kubernetes.io/role/internal-elb,Values=1" \
  --region us-east-2

### Then Check Subnet Tags
aws ec2 describe-subnets \
  --region us-east-2 \
  --query "Subnets[].{SubnetId:SubnetId,Tags:Tags}"

# After the fix
kubectl get ec2nodeclass
