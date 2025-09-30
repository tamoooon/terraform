# modules/alb/variables.tf

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_listener_port" {
  description = "Port for the listener"
  type        = number
}

variable "alb_protocol" {
  description = "Listener protocol"
}

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞として使用）"
  type        = string
}

variable "common_tags" {
  description = "プロジェクト共通のタグ"
  type        = map(string)
}

variable "certificate_arn" {
  description = "ACM証明書のARN"
  type        = string
  default     = ""
}