/*
  Resource: aws_internet_gateway.igw
  ----------------------------------
  Provisions an Internet Gateway (IGW) and attaches it to the primary VPC.
  The IGW enables outbound and inbound connectivity between resources in
  public subnets and the public internet. This is required for EC2 instances
  that need direct internet access (e.g., package installation, public-facing applications). 
  Tags include environment and project identifiers for clear resource tracking and lifecycle management.
*/

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-igw"
  })
}
