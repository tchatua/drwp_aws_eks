/*
  Resource: aws_vpc.main
  -----------------------
  Defines the primary Virtual Private Cloud (VPC) for the environment.
  This establishes the core networking boundary and provides the CIDR
  range from which all subnets and routing components are derived.
  DNS support and hostnames are enabled to allow internal name
  resolution and automatic hostname assignment for EC2 instances.

  The lifecycle configuration ensures safe updates:
    - create_before_destroy:
        Allows Terraform to provision a replacement VPC before removing
        the existing one, reducing the risk of downtime during changes
        that require recreation.
    - prevent_destroy (optional):
        When enabled, protects the VPC from accidental deletion. This is
        typically used in production environments where destroying the
        VPC would cause widespread service disruption.
*/

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-vpc"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}