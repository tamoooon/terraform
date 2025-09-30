# modules/acm/output.tf

output "cert_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}
