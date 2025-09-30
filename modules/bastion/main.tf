# modules/bastion/main.tf

resource "aws_security_group" "bastion_sg" {
  name   = "${var.project_name}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-bastion-sg"
    }
  )

  lifecycle {
    ignore_changes = [ingress]
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_name

  associate_public_ip_address = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-bastion"
    }
  )
}
