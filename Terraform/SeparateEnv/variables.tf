# 환경별로 다른 tf 파일을 생성하였지만 variable 파일은 하나로 함게 사용

variable "region" {
  description = "This is the cloud hosting region where your webapp will be deployed."
}

variable "dev_prefix" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"
}

variable "prod_prefix" {
  description = "This is the environment where your webapp is deployed. qa, prod, or dev"
}
