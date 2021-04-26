terraform {
  backend "s3" {
    bucket = "terraform-ricky-apne2-tfstate"
    key = "Terraform/S3/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}
