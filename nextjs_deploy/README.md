# nextjs_deploy
Terraformを使ってNextJSをデプロイするためのS3＋Cloudfront環境を構築する

## インフラ構成
Route53、ACM、S3、Cloudfrontを使用しています。<br>
詳細は、インフラ構成図.png を見てください。

## ディレクトリ構成
1. [リソース名].tf：それぞれのリソースをコーディングしています。
2. main.tf：terraform や AWS Provider のバージョンを指定しています。
3. variables.tf：ドメイン名やS3バケット名を定義。ここの値を変えるだけで人それぞれの環境を構築できるようにしています。
4. provider.tf：AWSのリージョンを定義しています。


## 使用方法
### 前提
1. aws cli が使用可能
2. terraform コマンドが使用可能

### コマンド
```
// リポジトリのクローン
git clone https://github.com/hisuihisui/terraform_aws_deploy_practice.git

// ディレクトリ移動
cd terraform_aws_deploy_practice/nextjs_deploy

// variables.tf 内のドメイン名やS3バケット名を変更する

// terraform の実行
terraform init
terraform plan
terraform apply
```
