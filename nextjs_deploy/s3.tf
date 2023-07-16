# nextアプリを入れておくバケット
resource "aws_s3_bucket" "next_app_bucket" {
  # バケット名は一意のため、重複しないようにする
  bucket = local.next_app_bucket_name
  # 構築 → 削除 を繰り返す場合はコメントアウトを外す
  # これを設定しておくと、中身があってもdestroyコマンドでバケットを削除できる
  # force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "next_app_bucket" {
  bucket = aws_s3_bucket.next_app_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# ブロックパブリックアクセス
# S3に直接参照できないようにすべてtrueにしておく
resource "aws_s3_bucket_public_access_block" "next_app_bucket" {
  bucket = aws_s3_bucket.next_app_bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# バケットポリシーの紐づけ
resource "aws_s3_bucket_policy" "next_app_bucket" {
  bucket = aws_s3_bucket.next_app_bucket.id
  policy = data.aws_iam_policy_document.next_app_bucket.json
}

# バケットポリシーの中身を定義
data "aws_iam_policy_document" "next_app_bucket" {
  # OACに対してGetを許可
  statement {
    principals {
      type = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.next_app_bucket.arn}/*" ]
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [ aws_cloudfront_distribution.main.arn ]
    }
  }
}


# Cloudfrontのアクセスログ格納用バケット
resource "aws_s3_bucket" "cloudfront_log" {
  bucket = local.cloudfront_log_bucket_name
  # 構築 → 削除 を繰り返す場合はコメントアウトを外す
  # これを設定しておくと、中身があってもdestroyコマンドでバケットを削除できる
  # force_destroy = true
}

# private のACLを設定
# https://hisuiblog.com/error-aws-terraform-cloudfront-access-log-s3-enable-acl/
resource "aws_s3_bucket_ownership_controls" "cloudfront_log" {
  bucket = aws_s3_bucket.cloudfront_log.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloudfront_log" {
  depends_on = [ aws_s3_bucket_ownership_controls.cloudfront_log ]

  bucket = aws_s3_bucket.cloudfront_log.id
  acl    = "private"
}

# ログのライフサイクルルール
resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_log" {
  bucket = aws_s3_bucket.cloudfront_log.id

  rule {
    id = "rule-1"
    status = "Enabled"

    expiration {
      # 180日
      days = "180"
    }
  }
}

# バケットポリシーの紐づけ
resource "aws_s3_bucket_policy" "cloudfront_log" {
  bucket = aws_s3_bucket.cloudfront_log.id
  policy = data.aws_iam_policy_document.cloudfront_log.json
}

# バケットポリシーの中身を定義
data "aws_iam_policy_document" "cloudfront_log" {
  # OACに対してPutを許可
  statement {
    principals {
      type = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }
    actions = [ "s3:PutObject" ]
    resources = [ "${aws_s3_bucket.cloudfront_log.arn}/*" ]
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [ aws_cloudfront_distribution.main.arn ]
    }
  }
}
