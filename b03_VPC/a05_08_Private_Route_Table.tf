/*
  Resource: aws_route_table.private_rt
  ------------------------------------
  Creates the private route table for the VPC. This route table defines
  a default route (0.0.0.0/0) that sends outbound traffic from private
  subnets to the NAT Gateway. This allows instances in private subnets
  to access the internet for updates, package downloads, and external
  API calls while remaining unreachable from the public internet.

  Tags include environment and project identifiers to maintain clear
  visibility and lifecycle tracking across environments.
*/

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-private-rt"
  })
}

/*
  Resource: aws_route_table_association.private_rt_assoc
  ------------------------------------------------------
  Associates each private subnet with the private route table. This ensures
  that all private subnets inherit the default route to the NAT Gateway,
  enabling secure outbound-only internet access for internal workloads.

  The for_each expression automatically links every private subnet to the
  route table, ensuring consistent routing behavior across all AZs in the
  deployment.
*/

resource "aws_route_table_association" "private_rt_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}