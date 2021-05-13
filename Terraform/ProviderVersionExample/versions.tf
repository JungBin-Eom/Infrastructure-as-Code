# terraform block 안에 provider의 버전 명시
# terraform init을 하면 .terraform.lock.hcl 파일을 생성
# lock 파일에 provider 버전과 같은 제약사항 있음
# init할 때 -upgrade 옵션을 사용하면 provider를 최신 버전으로 업그레이드함

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }

  required_version = "~> 0.14"
}
