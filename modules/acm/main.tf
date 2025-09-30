# modules/acm/main.tf

locals {
  # Route53 レコード作成で使う「静的なキー集合」
  validation_domains = toset(concat([var.domain_name], var.subject_alternative_names))
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  tags = merge(var.common_tags, { Name = "${var.project_name}-acm" })

  lifecycle {
    create_before_destroy = true
  }
}

# domain_validation_options は apply 後に確定するが、
# for_each のキーは locals.validation_domains（静的）なのでOK。
resource "aws_route53_record" "cert_validation" {
  for_each = local.validation_domains

  zone_id = var.hosted_zone_id

  # 各ドメイン(each.key)に対応する DVO を見つけて使う
  name = one([
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_name
    if dvo.domain_name == each.key
  ])
  type = one([
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_type
    if dvo.domain_name == each.key
  ])
  records = [one([
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_value
    if dvo.domain_name == each.key
  ])]
  ttl = 300
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
