# modules/cloudfront/main.tf

locals {
  comment = "${var.project_name}-cloudfront"
}

# マネージドポリシー（既存利用）
data "aws_cloudfront_cache_policy" "caching_optimized" { name = "Managed-CachingOptimized" }
data "aws_cloudfront_cache_policy" "caching_disabled"  { name = "Managed-CachingDisabled" }
data "aws_cloudfront_origin_request_policy" "all_viewer" { name = "Managed-AllViewer" }

# OAC
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 バケットポリシー（OACのみ許可）
data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid     = "AllowCloudFrontOACRead"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cf_oac" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.s3_policy.json
}

# Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.price_class
  default_root_object = "index.html"
  comment             = local.comment
  web_acl_id          = var.web_acl_arn
  aliases             = [var.domain_name]

  origin {
    origin_id                = var.s3_bucket_domain_name
    domain_name              = var.s3_bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin {
    origin_id   = var.api_domain_name
    domain_name = var.api_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # 既存：allow-all（後で redirect-to-https に変えてOK）
  default_cache_behavior {
    target_origin_id         = var.s3_bucket_domain_name
    viewer_protocol_policy   = var.viewer_protocol_policy
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id
    allowed_methods          = ["GET","HEAD","OPTIONS","PUT","POST","PATCH","DELETE"]
    cached_methods           = ["GET","HEAD"]
    compress                 = true
  }

  ordered_cache_behavior {
    path_pattern             = "/api/*"
    target_origin_id         = var.api_domain_name
    viewer_protocol_policy   = var.viewer_protocol_policy
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id
    allowed_methods          = ["GET","HEAD","OPTIONS","PUT","POST","PATCH","DELETE"]
    cached_methods           = ["GET","HEAD"]
    compress                 = true
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_cert_arn_use1
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-cloudfront" })
}
