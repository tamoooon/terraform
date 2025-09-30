# modules/route53/outputs.tf

output "api_record_fqdn" {
  value       = try(aws_route53_record.api_to_alb[0].fqdn, null)
  description = "api サブドメインのFQDN"
}
