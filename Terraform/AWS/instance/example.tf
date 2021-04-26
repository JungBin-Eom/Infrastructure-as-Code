provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_instance" "app_server" {
  ami = "ami-0078a04747667d409"
  instance_type = "t2.micro"

  tags = {
    Name = "RickyTerraformInstance"
  }
}