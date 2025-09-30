# modules/ec2/variables.tf

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID of the ALB to allow incoming traffic to EC2"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN to attach the EC2 instance to"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID to use for launching the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance (e.g., t3.micro)"
  type        = string
}

variable "ec2_user_data" {
  type        = string
  description = "User data script to initialize EC2 instance"
}

variable "bastion_sg_id" {
  description = "踏み台EC2のセキュリティグループID（SSH接続元）"
  type        = string
}

variable "key_name" {
  description = "SSH接続用のキーペア名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞として使用）"
  type        = string
}

variable "common_tags" {
  description = "プロジェクト共通のタグ"
  type        = map(string)
}