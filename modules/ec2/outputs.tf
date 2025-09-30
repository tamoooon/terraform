# modules/ec2/output.tf

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "private_ip" {
  value = aws_instance.web.private_ip
}