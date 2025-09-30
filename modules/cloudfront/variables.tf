# modules/cloudfront/variables.tf

variable "domain_name"        { type = string }
variable "api_domain_name"    { type = string }
variable "s3_bucket_name"     { type = string }
variable "s3_bucket_arn"      { type = string }
variable "s3_bucket_domain_name" { type = string }
variable "acm_cert_arn_use1"  { type = string }
variable "price_class"        {
  type = string 
  default = "PriceClass_200" 
}
variable "enable_logging"     { 
  type = bool    
  default = false 
}
variable "log_bucket"         { 
  type = string
  default = null 
}
variable "web_acl_arn"        { 
  type = string
  default = null
}
variable "project_name"       { 
  type = string
  default = "app" 
}
variable "common_tags" {
  description = "プロジェクト共通のタグ"
  type        = map(string)
}
variable "viewer_protocol_policy" {
  type = string
  default = "allow-all" 
}
