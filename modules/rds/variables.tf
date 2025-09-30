# modules/rds/variables.tf

variable "vpc_id" {}
variable "db_subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  description = "EC2インスタンスのセキュリティグループID（RDSへのアクセス許可）"
  type        = string
}

variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

variable "db_user" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞として使用）"
  type        = string
}

variable "common_tags" {
  description = "プロジェクト共通のタグ"
  type        = map(string)
}