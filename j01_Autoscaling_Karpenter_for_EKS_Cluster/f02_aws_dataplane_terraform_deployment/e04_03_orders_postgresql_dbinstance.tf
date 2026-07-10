# RDS PostgreSQL Instance
resource "aws_db_instance" "orders_postgres" {
  identifier             = "orders-postgres-db"
  engine                 = "postgres"
  # engine_version         = "17.6"
  engine_version         = "17.9"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  db_subnet_group_name   = aws_db_subnet_group.rds_postgresql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_postgresql_sg.id]

  db_name  = "ordersdb"
  username = local.app_store_secret_json.MYSQL_USER # Getting from e01_03_catalog_rds_mysql_credentials.tf and AWS Secret Manager secret "catalog-db-secret-1"
  password = local.app_store_secret_json.MYSQL_PASSWORD # Getting from e01_03_catalog_rds_mysql_credentials.tf and AWS Secret Manager secret "catalog-db-secret-1"
  port     = 5432

  multi_az            = false
  storage_encrypted   = true
  publicly_accessible = false
  skip_final_snapshot = true

  backup_retention_period = 7
  deletion_protection     = false

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-orders-rds-postgres"
    Environment = var.environment_name
  })
}

# Outputs for RDS endpoint and credentials
output "orders_rds_postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint for Orders microservice"
  value       = aws_db_instance.orders_postgres.endpoint
}

output "orders_rds_postgresql_db_name" {
  value = aws_db_instance.orders_postgres.db_name
}
