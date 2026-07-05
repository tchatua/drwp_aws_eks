locals {
  azs                  = slice(data.aws_availability_zones.available_zone.names, 0, 3)
  public_subnet_cidrs  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr_block, var.subnet_newbits_cidr_block, k)]
  private_subnet_cidrs = [for k, az in local.azs : cidrsubnet(var.vpc_cidr_block, var.subnet_newbits_cidr_block, k + 10)]
}