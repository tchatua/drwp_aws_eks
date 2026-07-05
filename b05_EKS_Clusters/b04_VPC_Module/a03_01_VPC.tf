module "vpc" {
  source                    = "./b01_module/a01_vpc"
  environment_name          = var.environment_name
  project_name              = var.project_name
  tags                      = var.tags
  vpc_cidr_block            = var.vpc_cidr_block
  subnet_newbits_cidr_block = var.subnet_newbits_cidr_block
}