resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project_name}-cf-waf"
  description = "CloudFront WAF (Bot Control only)"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-cf-waf"
    sampled_requests_enabled   = true
  }

  # ★ Bot Control だけを有効化（最小）
  rule {
  name     = "AWSManagedRulesBotControlRuleSet"
  priority = 10

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesBotControlRuleSet"
      vendor_name = "AWS"

      managed_rule_group_configs {
        aws_managed_rules_bot_control_rule_set {
          inspection_level = var.bot_inspection_level  # "COMMON" or "TARGETED"
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWSManagedRulesBotControlRuleSet"
    sampled_requests_enabled   = true
  }
}

  tags = var.common_tags
}