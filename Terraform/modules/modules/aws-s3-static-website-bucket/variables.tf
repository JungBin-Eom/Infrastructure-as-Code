# Input variable definitions
# module의 입력값은 대부분 variable로 처리
# .tfvars 파일로 variable 입력하기 편하게
variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type = map(string)
  default = {}
}
