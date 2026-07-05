/*
Resource: aws_subnet.private
  ----------------------------
  Creates one private subnet per Availability Zone using a for_each
  expression that maps each AZ to its corresponding CIDR block.
  These subnets do not assign public IPs and are intended for
  internal workloads such as application servers, databases, and
  services that should not be directly exposed to the internet.

  The lifecycle rule `create_before_destroy` ensures safe updates
  when subnet definitions change by allowing Terraform to provision
  replacement subnets before removing existing ones. The optional
  `prevent_destroy` safeguard can be enabled to protect critical
  private subnets from accidental deletion in production environments.

  Tags include environment and project identifiers, along with the
  AZ name, to maintain clear visibility across multi-AZ deployments.
*/

resource "aws_subnet" "private" {
  for_each          = { for idx, az in local.azs : az => local.private_subnet_cidrs[idx] }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-private-subnet-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
  }
}