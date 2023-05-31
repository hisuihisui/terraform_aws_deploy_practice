# ACM証明書を定義
resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# レコードのチェック
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = flatten([ values(aws_route53_record.cert)[*].fqdn ])
}
