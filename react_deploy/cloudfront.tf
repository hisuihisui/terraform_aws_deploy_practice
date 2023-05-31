# Cloudfrontを定義
resource "aws_cloudfront_distribution" "main" {
  # オリジンの設定
  origin {
    origin_id = aws_s3_bucket.react_app_bucket.id
    domain_name = aws_s3_bucket.react_app_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  enabled = true

  # アクセスログの設定
  logging_config {
    bucket = aws_s3_bucket.cloudfront_log.bucket_domain_name
    # Cookieをログに含めるか
    include_cookies = false
    prefix = "cloudfront/"
  }

  default_cache_behavior {
    target_origin_id = aws_s3_bucket.react_app_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    cached_methods = [ "GET", "HEAD" ]
    allowed_methods = [ "GET", "HEAD" ]
    forwarded_values {
      query_string = false
      headers = [ ]
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn = aws_acm_certificate.cert.arn
    # ssl_support_method = "sni-only"
    # minimum_protocol_version = "TLSv1"
  }
}

# OACを作成
resource "aws_cloudfront_origin_access_control" "main" {
  name = "cf-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}
