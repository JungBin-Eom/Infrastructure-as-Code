variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "172.16.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "172.16.10.0/24"
}

variable "aws_region" {
  description = "The AWS region to deploy your instance"
  default     = "ap-northeast-2"
}

variable "name" {
  description = "The username assigned to the infrastructure"
  default     = "terraform"
}

variable "team" {
  description = "The team responsible for the infrastructure"
  default     = "hashicorp"
}

variable "high_availability" {
  type = bool
  description = "If this is a multiple instance deployment, choose 'true' to deploy 3 instances"
  default = true
}