/*
  ##############################################
  RDS MySQL — DEVELOPMENT / NON‑PRODUCTION
  ##############################################
  This instance is optimized for dev/test environments:
  - Low‑cost instance class
  - Minimal backups
  - No Multi‑AZ
  - No final snapshot
  - Fast teardown
  - Credentials sourced from Secrets Manager JSON
*/
# RDS MySQL Database Instance 
resource "aws_db_instance" "catalog_rds" {
  identifier     = "mydb3"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  # Storage
  allocated_storage = 20

  # Initial DB
  db_name  = "catalogdb"
  username = local.app_store_secret_json.MYSQL_USER
  password = local.app_store_secret_json.MYSQL_PASSWORD

  # Networking
  db_subnet_group_name     = aws_db_subnet_group.rds_private.name
  vpc_security_group_ids   = [aws_security_group.rds_mysql_sg.id]
  skip_final_snapshot      = true
  publicly_accessible      = false
  delete_automated_backups = true

  # High Availability
  multi_az = false

  # Backups & Snapshots
  backup_retention_period = 1

  # Monitoring
  # Maintenance
  # Parameter group for MySQL tuning

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-catalog-rds-mysql"
  })
}
# Outputs
output "catalog_rds_endpoint" {
  description = "RDS endpoint for Catalog microservice"
  value       = aws_db_instance.catalog_rds.address
}

output "catalog_rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_mysql_sg.id
}