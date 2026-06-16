# AWS EKS Cluster Creation with Terraform

## Prerequisite: Create Custom VPC

```sh
#!/bin/bash

set -e  # Exit immediately if any command fails

echo "----------------------------------"
echo "STEP1:Creating VPC using Terraform"
echo "----------------------------------"

cd b04_VPC_Module/ || { echo "ERROR: VPC module directory not found"; exit 1; }

terraform init
terraform apply -auto-approve
```
