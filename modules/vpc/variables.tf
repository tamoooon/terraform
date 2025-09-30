# modules/vpc/variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the private subnet 1"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the private subnet 2"
}

variable "availability_zone_1" {
  description = "AZ for public subnet 1"
  type        = string
}

variable "availability_zone_2" {
  description = "AZ for public subnet 2"
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