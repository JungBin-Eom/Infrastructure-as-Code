terraform {
  required_version = ">= 0.13.0"
}

provider "aws" {
  region = var.aws_region
}

resource "random_id" "id" {
  byte_length = 8  
}

# locals는 표현식을 여러번 재사용하기 위해 사용하는 키워드
# 표현식은 변수처럼 사용할 수 없지만 locals를 통해 재사용은 가능
locals {
  # conditional expression
  # 조건이 참인지 거짓인지에 따라 동작 결정
  #       condition    then  true  else false
  name = (var.name != "" ? var.name : random_id.id.hex) 
  owner = var.team
  common_tags = {
    Owner = local.owner
    Name = local.name
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = local.common_tags
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.cidr_subnet
  tags = local.common_tags
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_elb" "learn" {
  name    = "Learn-ELB"
  subnets = [aws_subnet.subnet_public.id]
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = aws_instance.ubuntu[*].id
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = local.common_tags
}


resource "aws_instance" "ubuntu" {
  # high_availability 변수가 true이면 인스턴스 3개 생성, 아니면 1개 생성
  count = (var.high_availability == true ? 3 : 1)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = (count.index == 0 ? true : false)
  subnet_id                   = aws_subnet.subnet_public.id
  tags = merge(local.common_tags)
}
