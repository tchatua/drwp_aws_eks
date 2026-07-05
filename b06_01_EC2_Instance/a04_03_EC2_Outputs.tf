# Public IP (for accessing your server in browser or SSH)
output "ec2_public_ip" {
    description = "EC2 Public IP Address - Use this to access your server in a browser or via SSH"
  value = aws_instance.ec2_vm.public_ip
}

# Public DNS (alternative to IP)
output "ec2_public_dns" {
    description = "EC2 Public DNS Name - Use this to access your server via DNS"
  value = aws_instance.ec2_vm.public_dns
}

# Private IP (used inside VPC)
output "ec2_private_ip" {
    description = "EC2 Private IP Address - Use this for internal communication within the VPC"
  value = aws_instance.ec2_vm.private_ip
}

# Instance ID (useful for automation/scripts)
output "ec2_instance_id" {
    description = "EC2 Instance ID - Use this for automation and scripting purposes"
  value = aws_instance.ec2_vm.id
}
