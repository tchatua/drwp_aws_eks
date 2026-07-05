# Security Group for RDS MySQL
resource "aws_security_group" "rds_mysql_sg" {
  name        = "${local.name_prefix}-rds-mysql-sg"
  description = "Allow MySQL access from EKS cluster"
  vpc_id      = data.terraform_remote_state.vpc.outputs.aws_vpc_id

  ingress {
    description = "Allow MySQL from EKS cluster security group"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-rds-mysql-sg"
  })
}