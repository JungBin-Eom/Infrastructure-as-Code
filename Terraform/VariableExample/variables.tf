# Variable declarations

variable "aws_region" {
  description = "AWS region" # variable의 목적
  type = string # 갖고 있는 데이터의 타입
  default = "ap-northeast-2" # 기본값(설정하지 않으면 apply할 때 직접 입력)
}

# simple variable type

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "instance_count" {
  description = "Number of instances to provision"
  type = number
  default = 2
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC"
  type = bool
  default = false
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type = number
  default = 2
}

variable "private_subnet_count" {
  description = "Number of priavte subnets"
  type = number
  default = 2
}

# collection variable type

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type = list(string) # collection(simple) O | collection(collection) X
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
  ]
}

# variable for tags
variable "resource_tags" {
  description = "Tags to set for all resources"
  type = map(string) # map의 key는 항상 string
  default = {
    project = "ricky-project",
    environment = "dev"
  }

  # 조건에 맞는 값을 넣기 위해서 validation
  validation {
    condition     = length(var.resource_tags["project"]) <= 16 && length(regexall("/[^a-zA-Z0-9-]/", var.resource_tags["project"])) == 0
    error_message = "The project tag must be no more than 16 characters, and only contain letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.resource_tags["environment"]) <= 8 && length(regexall("/[^a-zA-Z0-9-]/", var.resource_tags["environment"])) == 0
    error_message = "The environment tag must be no more than 8 characters, and only contain letters, numbers, and hyphens."
  }

}

# without default value
variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type = string
}