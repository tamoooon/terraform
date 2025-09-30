# modules/alb/output.tf

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "ALB DNS name for Route53 alias"
}

output "alb_zone_id" {
  value       = aws_lb.alb.zone_id
  description = "ALB hosted zone ID for Route53 alias"
}
