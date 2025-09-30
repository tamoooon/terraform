# modules/route53/main.tf

# api.<domain> -> ALB (A/ALIAS)
resource "aws_route53_record" "api_to_alb" {
  count   = var.create_api_record ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "${var.api_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name   # 例: mappin-alb-xxx.ap-northeast-1.elb.amazonaws.com
    zone_id                = var.alb_zone_id    # 例: Z14GRHDCWA56QT など
    evaluate_target_health = false
  }
}