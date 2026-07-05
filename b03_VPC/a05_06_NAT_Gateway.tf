/*
  Resource: aws_nat_gateway.nat_gw
  --------------------------------
  Provisions a managed NAT Gateway to enable outbound internet access
  for private subnets while keeping their resources unreachable from
  the public internet. The NAT Gateway is placed in the first public
  subnet and uses an Elastic IP for stable, routable connectivity.

  An explicit dependency on the Internet Gateway ensures correct
  provisioning order, preventing race conditions where the NAT
  Gateway could be created before the VPC has external connectivity.
  Tags include environment and project identifiers for consistent
  tracking across environments.
*/
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-nat-gw"
  })
  depends_on = [aws_internet_gateway.igw]
}