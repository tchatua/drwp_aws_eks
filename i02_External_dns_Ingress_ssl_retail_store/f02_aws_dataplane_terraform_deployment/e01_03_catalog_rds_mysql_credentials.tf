# Use existing AWS Secrets Manager Secret (already created manually)
data "aws_secretsmanager_secret" "app_store_secret" {
  name = "catalog-db-secret-1"
}

data "aws_secretsmanager_secret_version" "app_store_secret_value" {
  secret_id = data.aws_secretsmanager_secret.app_store_secret.id
}

locals {
  app_store_secret_json = jsondecode(data.aws_secretsmanager_secret_version.app_store_secret_value.secret_string)
}


# --------------------------------------------------------------------
# ⚠️ TEMPORARY DEBUG OUTPUTS (NOT RECOMMENDED FOR PRODUCTION) ⚠️
# --------------------------------------------------------------------
# These outputs are only for verifying that Terraform correctly fetched
# username and password from AWS Secrets Manager. 
# REMOVE or comment out after validation to avoid exposing credentials.
# --------------------------------------------------------------------

output "debug_app_store_secret_username" {
  description = "⚠️ For testing only: DB username from Secrets Manager ⚠️"
  value       = local.app_store_secret_json.MYSQL_USER
  sensitive   = true
}

output "debug_app_store_secret_password" {
  description = "⚠️ For testing only: DB password from Secrets Manager ⚠️"
  value       = local.app_store_secret_json.MYSQL_PASSWORD
  sensitive   = true
}

# If you want to actually see the values just once (for validation), you can run:
# terraform output -json | jq -r '.debug_app_store_secret_username.value'
# terraform output -json | jq -r '.debug_app_store_secret_password.value'
