# root/variables.tf

# プロジェクト・環境情報
variable "aws_region" {
  description = "リージョン名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名（リソース名やタグに使用）"
  type        = string
}

variable "domain_name" {
  description = "ACM証明書を発行するFQDN（例: example.com）"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53のホストゾーンID（ドメイン名に対応）"
  type        = string
}

variable "environment" {
  description = "環境名（dev/stg/prodなど）"
  type        = string
}

# VPC・サブネット構成
variable "vpc_cidr" {
  description = "VPC全体のCIDRブロック"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "パブリックサブネット1のCIDRブロック（AZ1用）"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "パブリックサブネット2のCIDRブロック（AZ2用）"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "プライベートサブネット1のCIDRブロック（AZ1用）"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "プライベートサブネット2のCIDRブロック（AZ2用）"
  type        = string
}

variable "availability_zone_1" {
  description = "AZ1の名前（例: ap-northeast-1a）"
  type        = string
}

variable "availability_zone_2" {
  description = "AZ2の名前（例: ap-northeast-1c）"
  type        = string
}

# ALB関連
variable "alb_listener_port" {
  description = "ALBリスナーのポート番号（例: 80）"
  type        = number
}

variable "alb_protocol" {
  description = "ALBリスナーのプロトコル（例: HTTP or HTTPS）"
  type        = string
}

# EC2関連
variable "instance_ami" {
  description = "起動に使用するEC2のAMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2インスタンスのタイプ（例: t3.micro）"
  type        = string
}

variable "ec2_user_data" {
  description = "EC2の初期化に使用するuser dataスクリプト"
  type        = string
}

# 踏み台EC2関連
variable "bastion_ami" {
  description = "踏み台EC2のAMI ID"
  type        = string
}

variable "bastion_instance_type" {
  description = "踏み台EC2のインスタンスタイプ"
  type        = string
}

variable "key_name" {
  description = "SSH鍵の名前"
  type        = string
}

variable "my_ip_cidr" {
  description = "SSH接続元のIP（例: 203.0.113.0/32）"
  type        = string
}

# RDS関連
variable "db_name" {
  description = "RDS データベース名"
  type        = string
}

variable "db_user" {
  description = "RDS 接続ユーザー名"
  type        = string
}

variable "db_password" {
  description = "RDS 接続パスワード"
  type        = string
  sensitive   = true
}


# CloudFront（import 用の最小セット）
variable "origin_domain_name" {
  description = "CloudFrontのオリジンに設定するドメイン名（例: ALBのDNS名やS3静的サイトのFQDN）"
  type        = string
  default     = "example.com"
}

variable "acm_cert_arn_use1" {
  description = "CloudFrontで使用するACM証明書ARN（必ずus-east-1）。未設定の場合はデフォルト証明書を使用"
  type        = string
  default     = ""
}

variable "s3_bucket_domain_name" {
  description = "S3をオリジンにする場合のバケットのドメイン名（例: my-bucket.s3.ap-northeast-1.amazonaws.com）。未使用なら空"
  type        = string
  default     = ""
}

variable "s3_bucket_arn" {
  description = "S3バケットのARN（OAC/OAI等で参照する場合）。未使用なら空"
  type        = string
  default     = ""
}
variable "s3_bucket_name" {
  description = "S3バケット名"
  type        = string
  default     = ""
}

variable "cf_web_acl_arn" {
  type = string
  default = ""
}
