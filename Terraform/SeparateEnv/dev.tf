terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

# unizue S3 bucket 이름을 위한 random 리소스
# 여기서 초기화된 리소스는 디렉토리 내의 모든 리소스에 적용됨
# length=4로 수정하면 prod의 random_pet length도 4가 됨(hidden dependency)
resource "random_pet" "petname" {
  length    = 3
  separator = "-"
}

# dev와 prod 환경별로 다른 S3 bucket 생성
# 같은 main.tf파일에 서로 다른 환경의 bucket resource를 정의하므로 관리하기 어려움
# 환경별로 다른 tf파일에 정의하는것이 관리하기 좋다.
resource "aws_s3_bucket" "dev" {
  bucket = "${var.dev_prefix}-${random_pet.petname.id}"
  acl    = "public-read"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.dev_prefix}-${random_pet.petname.id}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"

  }
  force_destroy = true
}

resource "aws_s3_bucket_object" "dev" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket.dev.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"

}