# modules/acm/variables.tf

variable "domain_name" {
  description = "ACM証明書を発行するFQDN（例: example.com）"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53のホストゾーンID（ドメイン名に対応）"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名（リソース名の接頭辞として使用）"
  type        = string
}

variable "common_tags" {
  description = "共通で付けるタグ（Map型）"
  type        = map(string)
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}