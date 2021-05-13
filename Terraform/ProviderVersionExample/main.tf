# provider의 버전이 바뀌면 충돌이 발생할 수 있음
# 버전을 명시하지 않으면 테라폼은 자동으로 최신 버전의 Provider를 사용함
# 이를 해결하기 위해
# 1. provider version을 명시하는 block 선언
# 2. dependency lock file 생성

provider "aws" {
  region = "ap-northeast-2"
}

resource "random_pet" "petname" {
  length    = 5
  separator = "-"
}

resource "aws_s3_bucket" "sample" {
  bucket = random_pet.petname.id
  acl    = "public-read"

  # region = "ap-northeast-2" -> AWS v3.0.0 이후부터는 bucket에 region 속성 없음
}
