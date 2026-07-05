# Resource: EC2 Instance
resource "aws_instance" "ec2_vm" {
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  user_data = file("${path.module}/sh01_app1_install.sh")

  tags = merge(var.tags, {
    "Name" = "EC2 Demo"
  })
}