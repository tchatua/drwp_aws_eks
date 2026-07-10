# RDS PostgreSQL Database Subnet Group for Orders Microservice
resource "aws_db_subnet_group" "rds_postgresql_subnet_group" {
  name        = "${local.name_prefix}-rds-postgresql-subnet-group"
  description = "Subnet group for Orders RDS PostgreSQL"
  subnet_ids  = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-rds-postgresql-subnet-group"
  })
}