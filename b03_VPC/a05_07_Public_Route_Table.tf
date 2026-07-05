
/*
  Resource: aws_route_table.public_rt
  -----------------------------------
  Creates the public route table for the VPC. This route table includes
  a default route (0.0.0.0/0) that directs all outbound traffic to the
  Internet Gateway, enabling internet connectivity for resources placed
  in public subnets.

  Tags include environment and project identifiers for clear visibility
  and lifecycle tracking across environments.
*/

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-public-rt"
  })
}

/*
  Resource: aws_route_table_association.public_rt_assoc
  -----------------------------------------------------
  Associates each public subnet with the public route table. This ensures
  that all subnets designated as public inherit the default route to the
  Internet Gateway, enabling outbound internet access for EC2 instances
  and other public-facing resources.

  The for_each expression automatically links every public subnet to the
  route table, maintaining consistency across multi-AZ deployments.
*/

resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}