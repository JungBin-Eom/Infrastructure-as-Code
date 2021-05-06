terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "2.69.0"
    }
  }
}

provider aws {
  region = "ap-northeast-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ec2 instance와 elastic ip의 dependency 존재(dependency)
# 원래 terraform에서 dependency을 파악하여 순서에 맞게 리소스 생성 및 삭제함
# 때때로 dependency 파악 못할때도 있음 -> 'depends_on' 인자를 사용하여 명시적으로 dependency를 설정

resource "aws_instance" "example_a" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
}

resource "aws_instance" "example_b" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.example_a.id # 여기서 example_a의 id를 참조하므로 dependency 확인
}

# example_c 인스턴스가 S3를 사용한다고 가정
# 이는 명시적으로 dependency가 드러나있지 않기 때문에 terraform이 순서를 조정할 수 없음
# 'depends_on'이라는 인자를 사용하여 해당 리소스가 생성되기 전에 먼저 생성되어야 하는 리소스를 설정
# dependency가 있는 리소스가 생성완료 될 때까지 기다림
# 아래는 S3 Bucket->EC2 Instance->SQS Queue 순서로 생성
resource "aws_s3_bucket" "example" {
  acl = "private"
}

resource "aws_instance" "example_c" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  depends_on = [
    aws_s3_bucket.example
  ]
}

# 새로운 모듈을 사용하기 위해서 'terraform get'명령어 사용
module "example_sqs_queue" {
  source = "terraform-aws-modules/sqs/aws"
  version = "2.1.0"

  depends_on = [
    aws_s3_bucket.example,
    aws_instance.example_c
  ]
}