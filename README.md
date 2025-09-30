# Terraform AWS Infrastructure Setup

## Architecture
<img width="770" height="422" alt="image" src="https://github.com/user-attachments/assets/1da90087-0a69-4d19-9a96-877833e50c00" />

## 作成されるリソース
このリポジトリは、Terraform を用いて主に以下の AWS リソースを構築します：

- カスタム VPC（パブリック/プライベートサブネット）
- Application Load Balancer
- EC2 インスタンス（Django + Gunicorn + Nginx コンテナ構成を想定）
- Amazon RDS（PostgreSQL）データベース
- ACM（AWS Certificate Manager）によるSSL証明書の自動作成・DNS検証
- Route 53 ホストゾーンのレコード
- S3
- WAF

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

## 🧹 後始末
```bash
terraform destroy -var-file="terraform.tfvars"
```
