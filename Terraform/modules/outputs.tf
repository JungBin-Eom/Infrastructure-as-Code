# Output variable definitions
# module의 출력값
# module.<MODULE_NAME>.<OUTPUT_NAME>으로 설정 가능

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances.public_ip
}

# module의 output을 root module의 output으로 사용
output "website_bucket_arn" {
  description = "ARN of the bucket"
  value       = module.website_s3_bucket.arn
}

output "website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = module.website_s3_bucket.name
}

output "website_bucket_endpoint" {
  description = "Domain name of the bucket"
  value       = module.website_s3_bucket.website_endpoint
}
