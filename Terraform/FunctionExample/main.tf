terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  region  = var.aws_region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_8080" {
  name   = "sg_8080"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 인스턴스에 적용할 ssh key 리소스
resource "aws_key_pair" "ssh_key" {
  key_name = "ssh_key"
  public_key = file("ssh_key.pub") # public key를 file 함수를 통해 읽어옴
}

resource "aws_instance" "web" {
  # lookup 함수를 통해 arg1의 map에서 arg2의 key값을 갖는 ami를 찾음
  ami                         = lookup(var.aws_amis, var.aws_region)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22.id, aws_security_group.sg_8080.id]
  associate_public_ip_address = true
  # user_data로 템플릿 파일을 사용
  # 템플릿 파일에 있는 레퍼런스 부분을 variable로 정의
  user_data = templatefile("user_data.tmpl", { department = var.user_department, name = var.user_name })
  key_name = aws_key_pair.ssh_key.key_name
}
