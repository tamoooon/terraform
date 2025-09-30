# Makefile

# 環境ディレクトリ（envs/staging や envs/production）
STAGING_DIR=envs/staging
PRODUCTION_DIR=envs/production

# staging環境の初期化とapply
init-staging:
	cd $(STAGING_DIR) && terraform init

apply-staging:
	cd $(STAGING_DIR) && terraform apply -var-file=terraform.tfvars

plan-staging:
	cd $(STAGING_DIR) && terraform plan -var-file=terraform.tfvars

# production環境の初期化とapply
init-production:
	cd $(PRODUCTION_DIR) && terraform init

apply-production:
	cd $(PRODUCTION_DIR) && terraform apply -var-file=terraform.tfvars

plan-production:
	cd $(PRODUCTION_DIR) && terraform plan -var-file=terraform.tfvars

# bastion環境の初期化とapply
bastion-init:
	terraform init -target=module.bastion

bastion-plan:
	terraform plan -target=module.bastion

bastion-apply:
	terraform apply -auto-approve -target=module.bastion

bastion-destroy:
	terraform destroy -auto-approve -target=module.bastion