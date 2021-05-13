variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "aws_region" {
  description = "The AWS region to deploy your instance"
  default     = "ap-northeast-2"
}

variable "user_name" {
  description = "The user creating this infrastructure"
  default     = "terraform"
}

variable "user_department" {
  description = "The organization the user belongs to: dev, prod, qa"
  default     = "learn"
}

# 현재 region과 맞는 ami를 쓰기 위해 map 형태의 변수 생성
variable "aws_amis" {
  type = map
  default = {
    "ap-northeast-1" = "ami-0d53808c8c345ed07" # 도쿄
    "ap-northeast-2" = "ami-08508144e576d5b64" # 서울
    "ap-northeast-3" = "ami-0eab055d8530dd456" # 오사카
  }
}