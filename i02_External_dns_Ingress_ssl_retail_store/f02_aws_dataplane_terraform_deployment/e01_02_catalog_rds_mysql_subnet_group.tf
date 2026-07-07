# DB Subnet Group (using private subnets from VPC project)
resource "aws_db_subnet_group" "rds_private" {
  name       = "${local.name_prefix}-rds-private-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-rds-private-subnets"
  })
}