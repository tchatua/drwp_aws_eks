/*
  Resource: aws_subnet.public
  ---------------------------
  Creates one public subnet per Availability Zone using a for_each
  expression that maps each AZ to its corresponding CIDR block.
  These subnets are configured to assign public IPs on instance
  launch, making them suitable for internet-facing workloads.

  The lifecycle rule `create_before_destroy` ensures zero-downtime
  updates when subnet definitions change. Tags include environment
  and project identifiers, along with the AZ name for clear
  identification across multi-AZ deployments.

  The optional `prevent_destroy` safeguard can be enabled to protect
  critical networking components from accidental deletion. When set
  to true, Terraform will refuse to destroy the subnet—even during
  updates that require recreation—forcing an explicit override to
  avoid unintended outages.
*/

resource "aws_subnet" "public" {
  for_each                = { for idx, az in local.azs : az => local.public_subnet_cidrs[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-public-subnet-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}