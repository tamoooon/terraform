# root/provider.tf

provider "aws" {
  region = "ap-northeast-1" # 東京リージョン
  # profile = "deploy-user"
  # profile = "assumed-role"  # ~/.aws/credentials のプロファイル名
}


# CloudFront/ACM 用（必ず us-east-1）
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
  # profile = "assumed-role"
}