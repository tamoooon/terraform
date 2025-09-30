# Terraform AWS Infrastructure Setup

このリポジトリは、Terraform を用いて以下の AWS リソースを構築します：

- カスタム VPC（パブリック/プライベートサブネット）
- Application Load Balancer（ALB + ACM による HTTPS 対応）
- EC2 インスタンス（Django + Gunicorn + Nginx コンテナ構成を想定）
- Amazon RDS（PostgreSQL）データベース
- ACM（AWS Certificate Manager）によるSSL証明書の自動作成・DNS検証

---

## 📁 ディレクトリ構成

```yaml
terraform/
├── modules
│   ├── acm
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── alb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── bastion
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tf
│   │   └── variables.tf
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda_schedule
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── start_instance.py
│   │   ├── start_instance.zip
│   │   ├── stop_instance.py
│   │   ├── stop_instance.zip
│   │   ├── variables.tf
│   │   └── zip.sh
│   ├── rds
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── route53
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── vpc
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── waf
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── versions.tf
├── main.tf               # 各モジュールを呼び出すルート定義
├── variables.tf          # ルートで使用する変数定義
├── terraform.tfvars      # 変数値の定義（環境ごとに切り替え可能）
├── locals.tf             # 共通タグなどのローカル定数
├── outputs.tf            # 出力情報（ALB DNS名、RDSエンドポイントなど）
```

---

## 🚀 セットアップ手順

### 1. 事前準備

- AWS CLI / IAM 認証情報を設定済みであること
- Terraform インストール済み

```bash
terraform -version
```

### 2. 実行コマンド
```bash
cd terraform/

# 初期化
terraform init

# 実行プラン確認
terraform plan -var-file="terraform.tfvars"

# 適用
terraform apply -var-file="terraform.tfvars"
```


## 📦 モジュール構成の概要
### ✅ VPC モジュール
- カスタム VPC（CIDR 指定可）
- Public / Private サブネット（AZごとに2つずつ）
- Internet Gateway, Route Table まで構成
- availability_zone 指定可

### ✅ ALB モジュール
- Application Load Balancer（マルチAZ構成）
- Security Group / Target Group / Listener 自動作成
- alb_name, port, protocol 指定可能
- EC2への通信を許可

### ✅ EC2 モジュール
- プライベートサブネットに EC2 インスタンスを作成
- ALB からの通信のみ許可
- Docker + Git を user_data でセットアップ
- ALBターゲットグループに登録済み

### ✅ RDS モジュール
- PostgreSQL RDS インスタンス（非公開・プライベートサブネット内）
- EC2からのアクセスのみ許可
- サブネットグループ + SG を自動構成

### ✅ ACM モジュール（証明書）
- ACM の DNS 検証による証明書発行
- Route 53 に CNAME レコードを自動作成
- ALB で HTTPS を有効にするための証明書 ARN を出力

## 📤 出力例
`terraform apply` 実行後に表示される主な出力：

```bash
Outputs:

alb_dns_name        = alb-dev-123456789.ap-northeast-1.elb.amazonaws.com
certificate_arn     = arn:aws:acm:ap-northeast-1:xxxxxxxxxxxx:certificate/abcde-12345
ec2_sg_id           = sg-0abc123def456
rds_endpoint        = mappin-db.c1xyzxyz.ap-northeast-1.rds.amazonaws.com:5432
vpc_id              = vpc-0123abcd
public_subnet_ids   = [subnet-xxxxxx1, subnet-xxxxxx2]
private_subnet_ids  = [subnet-yyyyyy1, subnet-yyyyyy2]
```


## 🧹 後始末
```bash
terraform destroy -var-file="terraform.tfvars"
```
