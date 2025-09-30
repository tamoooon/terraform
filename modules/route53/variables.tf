# modules/route53/variables.tf

variable "hosted_zone_id" { type = string }
variable "domain_name"    { type = string }

# api -> ALB
variable "create_api_record" { 
  type = bool  
  default = true 
}
variable "api_subdomain"     {
  type = string
  default = "api" 
}
variable "alb_dns_name"      {
  type = string 
} # module.alb.alb_dns_name
variable "alb_zone_id"       {
  type = string
} # module.alb.alb_zone_id
