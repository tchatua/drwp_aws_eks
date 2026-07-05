# Terraform Variables

## Default Values from variables_block.tf
```sh
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform apply --auto-approve
```

- Default values defined in variables_block.tf are used for any variables that don’t have values from higher-precedence sources.

## Environment Variables (TF_VAR_variable_name)

```sh
# Set environment variables (same shell where you will run Terraform)
export TF_VAR_environment_name="test"
export TF_VAR_aws_region="us-east-1"

# Verify if env variable is set
echo $TF_VAR_environment_name, $TF_VAR_aws_region
env | grep TF_

# Terraform Plan
terraform plan
```

##
```sh

```

##
```sh

```

##
```sh

```

##
```sh

```