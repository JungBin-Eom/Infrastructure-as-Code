provider "aws" {
  region = "ap-northeast-2"
}

provider "random" {}

# resource type은 resource provider에 _가 붙은 이름

# Unique한 EC2 인스턴스 이름을 생성하기 위한 리소스
resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-0078a04747667d409"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    # random_pet 리소스가 생성되지 않으면 aws_instance 리소스도 생성되지 않음(terraform dependency)
    Name = random_pet.name.id # resource_type.recource_name.attribute_name
  }
}

resource "aws_security_group" "web-sg" {
  name = "{random_pet.name.id}-sg"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
}

output "domain-name" {
  value = aws_instance.web.public_dns
}

output "application-url" {
  value = "${aws_instance.web.public_dns}/index.php"
}
