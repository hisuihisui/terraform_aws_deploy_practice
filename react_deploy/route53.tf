# ホストゾーンの参照
data "aws_route53_zone" "host_zone" {
  name = local.host_zone

}

# CloudFrontをAレコードとして定義
resource "aws_route53_record" "test" {
  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}

# ACMのDNS検証用レコード
resource "aws_route53_record" "cert" {
  # Set型をListへ変換
  # https://hisuiblog.com/error-aws-terraform-acm-dns-auth/
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name = each.value.name
  type = each.value.type
  # 検証するレコード
  # subject_alternative_names がある場合には複数指定
  records = [each.value.record]
  zone_id = data.aws_route53_zone.host_zone.zone_id
  ttl     = 60
}
