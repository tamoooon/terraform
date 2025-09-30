# modules/ec2/main.tf

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [var.bastion_sg_id]
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
      Name = "${var.project_name}-ec2-sg"
    }
  )
}

resource "aws_instance" "web" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data       = var.ec2_user_data
  key_name        = var.key_name


  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-ec2-a"
    }
  )
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web.id
  port             = 80
}
