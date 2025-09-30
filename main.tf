# root/main.tf

module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidr_1   = var.public_subnet_cidr_1
  public_subnet_cidr_2   = var.public_subnet_cidr_2
  private_subnet_cidr_1  = var.private_subnet_cidr_1
  private_subnet_cidr_2  = var.private_subnet_cidr_2
  availability_zone_1    = var.availability_zone_1
  availability_zone_2    = var.availability_zone_2
  project_name           = var.project_name
  common_tags            = local.common_tags
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = [
    module.vpc.public_subnet_id_1,
    module.vpc.public_subnet_id_2
  ]  
  alb_listener_port   = var.alb_listener_port
  alb_protocol        = var.alb_protocol
  project_name        = var.project_name
  common_tags         = local.common_tags
  certificate_arn     = module.acm.cert_arn
}

module "route53" {
  source         = "./modules/route53"

  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name

  # api.<domain> -> ALB
  create_api_record = true
  api_subdomain     = "api"
  alb_dns_name      = module.alb.alb_dns_name
  alb_zone_id       = module.alb.alb_zone_id
}

# CloudFront 用 ACM（us-east-1）
module "acm_cf" {
  source         = "./modules/acm"
  providers      = { aws = aws.use1 }     # ★ これが無いと東京で作られます
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  project_name   = var.project_name
  common_tags    = local.common_tags
}

module "waf" {
  source    = "./modules/waf"
  providers = { aws = aws.use1 }     # ★ us-east-1 で作成
  project_name          = var.project_name
  common_tags           = local.common_tags
  bot_inspection_level  = "COMMON"
}

module "cloudfront" {
  source = "./modules/cloudfront"

  # ドメイン
  domain_name     = var.domain_name
  api_domain_name = "api.${var.domain_name}"   # ← ここが空だと origin.1 エラーになります

  # S3（module.s3 の出力をそのまま渡す）
  s3_bucket_name        = module.s3.bucket_name
  s3_bucket_domain_name = module.s3.bucket_domain_name
  s3_bucket_arn         = module.s3.bucket_arn

  # CloudFront の証明書（us-east-1）
  acm_cert_arn_use1 = module.acm_cf.cert_arn   # ★ 変数ではなく “acm_cf の出力” を渡す

  # 任意
  web_acl_arn            = module.waf.web_acl_arn
  price_class            = "PriceClass_All"
  viewer_protocol_policy = "allow-all"

  project_name = var.project_name
  common_tags  = local.common_tags
}

module "acm" {
  source          = "./modules/acm"
  domain_name    = "api.${var.domain_name}"   # ← ここがポイント
  hosted_zone_id  = var.hosted_zone_id
  project_name    = var.project_name
  common_tags     = local.common_tags
}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_id  = module.vpc.private_subnet_id_1
  alb_sg_id          = module.alb.alb_sg_id
  target_group_arn   = module.alb.target_group_arn
  instance_ami       = var.instance_ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  ec2_user_data      = var.ec2_user_data
  project_name       = var.project_name
  common_tags        = local.common_tags
  bastion_sg_id      = module.bastion.bastion_sg_id
}

module "bastion" {
  source            = "./modules/bastion"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id_1
  instance_ami      = var.bastion_ami
  instance_type     = var.bastion_instance_type
  key_name          = var.key_name
  my_ip_cidr        = var.my_ip_cidr
  project_name      = var.project_name
  common_tags       = local.common_tags
}

module "rds" {
  source         = "./modules/rds"
  vpc_id         = module.vpc.vpc_id
  ec2_sg_id = module.ec2.ec2_sg_id
  db_subnet_ids  = [
    module.vpc.private_subnet_id_1,
    module.vpc.private_subnet_id_2
  ]
  db_name        = var.db_name
  db_user        = var.db_user
  db_password    = var.db_password
  project_name   = var.project_name
  common_tags    = local.common_tags
}

module "lambda_schedule" {
  source            = "./modules/lambda_schedule"
  ec2_instance_id   = module.ec2.instance_id
  region            = var.aws_region
  project_name      = var.project_name
  common_tags       = local.common_tags
}

module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.s3_bucket_name
  project_name = var.project_name
  common_tags  = local.common_tags
}
