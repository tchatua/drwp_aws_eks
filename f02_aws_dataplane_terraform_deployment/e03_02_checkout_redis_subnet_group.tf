# AWS Elastic Cache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.name_prefix}-redis-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.aws_private_subnet_ids
}
