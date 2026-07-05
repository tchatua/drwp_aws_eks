
resource "aws_eip" "nat_eip" {
  tags = merge(var.tags, {
    Name = "${var.environment_name}-${var.project_name}-nat-eip"
  })
  depends_on = [aws_internet_gateway.igw]
}