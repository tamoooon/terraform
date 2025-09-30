# bastion_temp/output.tf

output "bastion_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_sg_id" {
  value = module.bastion.bastion_sg_id
}