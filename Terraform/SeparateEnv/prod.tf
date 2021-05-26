# dev의 required_provider, provider, random_pet과 충돌

# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#     }
#   }
# }

# provider "aws" {
#   region = var.region
# }

# unizue S3 bucket 이름을 위한 random 리소스
# resource "random_pet" "petname" {
#   length    = 3
#   separator = "-"
# }

# dev와 prod 환경별로 다른 S3 bucket 생성
# 같은 main.tf파일에 서로 다른 환경의 bucket resource를 정의하므로 관리하기 어려움
# 환경별로 다른 tf파일에 정의하는것이 관리하기 좋다.

# tf파일과 마찬가지로 state도 따로 정의하는 것이 좋다.
# 완전 다른 directory로 두어 관리하거나 workspace를 통해 분리할 수 있다.

# Directories: potential configuration differences
# 서로 다른 directory 내에서 tf 파일을 관리함으로써 완전히 다른 state가 생성됨

# Workspaces: avoid duplicating your configurations
# 같은 파일에 대해 서로 다른 workspace를 관리함으로써 state를 구분함
# tfvars 파일을 구분하여 생성함으로써 서로 다른 workspace에 각각 적용
# $ terrafrom workspace new ...
# $ terraform workspace select ...
# $ terraform destroy -var-file=...

resource "aws_s3_bucket" "prod" {
  bucket = "${var.prod_prefix}-${random_pet.petname.id}"
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
                "arn:aws:s3:::${var.prod_prefix}-${random_pet.petname.id}/*"
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

resource "aws_s3_bucket_object" "prod" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket.prod.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"

}
