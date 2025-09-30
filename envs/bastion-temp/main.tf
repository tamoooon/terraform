# bastion_temp/main.tf
module "bastion" {
  source            = "../../modules/bastion"
  vpc_id            = var.vpc_id
  public_subnet_id  = var.public_subnet_id
  instance_ami      = var.instance_ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  my_ip_cidr        = var.my_ip_cidr
  project_name      = var.project_name
  common_tags       = var.common_tags
}
