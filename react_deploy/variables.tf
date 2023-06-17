locals {
  # ホストゾーン
  host_zone = "hisui-app.com"
  # Cloudfrontと紐づけるFQDN
  domain_name = "test.hisui-app.com"
  # ReactアプリをデプロイするS3
  react_app_bucket_name = "hisui-react-app-bucket"
  # Cloudfrontのアクセスログを保存しておくS3
  cloudfront_log_bucket_name = "hisui-cloudfront-log-bucket"
}
