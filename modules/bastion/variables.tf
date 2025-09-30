# modules/bastion/variables.tf

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞として使用）"
  type        = string
}

variable "common_tags" {
  description = "共通タグ"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "踏み台EC2を配置するパブリックサブネット"
  type        = string
}

variable "instance_ami" {
  description = "踏み台EC2インスタンスのAMI ID"
  type        = string
}

variable "instance_type" {
  description = "踏み台EC2インスタンスのタイプ"
  type        = string
}

variable "key_name" {
  description = "SSH接続用のキーペア名"
  type        = string
}

variable "my_ip_cidr" {
  description = "SSH接続元のIP（例: 203.0.113.0/32）"
  type        = string
}