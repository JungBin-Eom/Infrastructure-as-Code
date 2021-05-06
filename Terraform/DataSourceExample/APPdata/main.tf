terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# VPCdata에서 output으로 출력된 region에 인스턴스를 배포해야 하므로
# output을 input으로 사용

# remote state data source를 추가하여 VPCdata의 state를 사용
# root level의 output value만 사용 가능
# .을 사용하여 하위로 내려가서 output을 찾아야함
data "terraform_remote_state" "vpc" {
  backend = "ocal"

  config = {
    path = "../VPCdata/terraform.tfstate"
  }
}

# Region별로 다른 AMI ID를 적용하기 위해 data 생성
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "2.4.0"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-tutorial-example"

  internal = false

  security_groups = data.terraform_remote_state.vpc.outputs.lb_security_group_ids
  subnets         = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  number_of_instances = length(aws_instance.app)
  instances           = aws_instance.app.*.id

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }
}

resource "aws_instance" "app" {
  # variable에 하나의 서브넷에 존재할 인스턴스 개수 정의
  # remote state에서 subnet의 수를 받아옴
  # 서로 곱하여 총 생성할 인스턴스 개수 결정
  count = var.instances_per_subnet * length(data.terraform_remote_state.vpc.outputs.private_subnet_ids)

  # ami ID는 region별로 다름
  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnet_ids[count.index % length(data.terraform_remote_state.vpc.outputs.private_subnet_ids)]
  vpc_security_group_ids = data.terraform_remote_state.vpc.outputs.app_security_group_ids
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF
}
