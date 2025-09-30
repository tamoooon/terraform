# root/output.tf

# VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

# パブリックサブネット（ALB用）
output "public_subnet_ids" {
  value = [
    module.vpc.public_subnet_id_1,
    module.vpc.public_subnet_id_2
  ]
}

# プライベートサブネット（EC2/RDS用）
output "private_subnet_ids" {
  value = [
    module.vpc.private_subnet_id_1,
    module.vpc.private_subnet_id_2
  ]
}

# ALB DNS名（外部アクセスに必要）
output "alb_dns_name" {
  value = module.alb.dns_name
}

# EC2のインスタンスID
output "ec2_instance_id" {
  value = module.ec2.instance_id
}

# EC2のプライベートIP（アプリケーション確認やSSH用）
output "ec2_private_ip" {
  value = module.ec2.private_ip
}

# EC2のセキュリティグループID（RDSが参照）
output "ec2_sg_id" {
  value = module.ec2.ec2_sg_id
}

# 踏み台EC2のパブリックIP
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

# 踏み台EC2のセキュリティグループID
output "bastion_sg_id" {
  value = module.bastion.bastion_sg_id
}

# RDSエンドポイント（アプリケーションからの接続に使用）
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

# RDSのサブネットグループ名（確認や管理用途）
output "rds_subnet_group_name" {
  value = module.rds.subnet_group_name
}

# CloudFrontのWAFのARN
output "cloudfront_waf_arn" {
  value = module.waf.web_acl_arn
}