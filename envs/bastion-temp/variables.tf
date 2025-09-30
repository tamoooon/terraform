# bastion_temp/variables.tf

variable "vpc_id" {
  description = "既存のVPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Bastionを配置するPublic Subnet"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID (Amazon Linuxなど)"
  type        = string
}

variable "instance_type" {
  description = "インスタンスタイプ（例: t3.micro）"
  type        = string
}

variable "key_name" {
  description = "SSH用キーペア名"
  type        = string
}

variable "my_ip_cidr" {
  description = "接続元IP（CIDR形式）"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞）"
  type        = string
}

variable "common_tags" {
  description = "共通タグ"
  type        = map(string)
}
