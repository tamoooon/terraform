# modules/lambda_schedule/variables.tf

variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "ec2_instance_id" {
  type = string
}

variable "region" {
  type = string
}
