# Terraform configuration
# 현재 terraform을 실행하고 있는 dirrectory에 있는 terraform 파일도 module
# 즉 모든 .tf 파일은 모듈
# 현재 실행중인 디렉토리가 root module이 되어 module{}을 만날 때 마다
# 다른 소스에서 모듈을 찾는 것

# 새로운 모듈을 사용하면 terraform init 혹은 terraform get 명령어로 모듈을 설치해야함
# 설치한 모듈은 .terraform/modules 디렉토리에 생성
# local modules은 테라폼이 해당 모듈과 연결되는 링크를 생성 -> 바로 적용될 수 있도록

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# module을 사용하기 위해서 input값을 설정

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  # 아래의 설정값이 각각 Input
  # Required는 default값이 없으므로 필수로 설정해야함
  # 대부분 var로 값이 설정되어있음

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "my-ec2-cluster"
  instance_count = 2

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# 생성한 S3 module 사용
# terraform get 명령어로 모듈 설치

module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  # bucket 이름은 유니크해야하기 때문에 날짜를 적어서 많이 사용
  bucket_name = "ricky-terraform-website-21-05-20" 

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}