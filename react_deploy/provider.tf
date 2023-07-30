# デフォルトではこちらの値が使われる
provider "aws" {
  region = "ap-northeast-1"
}

# こちらを指定するには
# provider = aws.virginia
# と記述する
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
