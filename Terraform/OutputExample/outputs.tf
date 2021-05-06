# Output declarations
# main.tf에 정의해도 되는데 알아보기 쉽게 output만 선언한 다른 파일을 만들자
# Terraform은 output을 state에 저장하므로 인프라의 변경이 없더라도 다시 프로비저닝함

output "vpc_id" {
  description = "ID of project VPC" # Optional이지만 적는 습관을 들이자
  value = module.vpc.vpc_id
}

output "lb_url" {
  description = "URL of load balancer"
  value = "https://${module.elb_http.this_elb_dns_name}/" # String Interpolation
}

output "web_server_count" {
  description = "Number of web servers provisioned"
  value = length(module.ec2_instances.instance_ids) # length function 사용
}

# sensitive data이 노출되는 것을 막기 위해 sensitive output 기능을 제공
# plan, apply, destroy, query all 할 때 sensitive로 설정된 데이터 보호
# 구체적인 output 이름으로 query를 수행하나 state 파일의 JSON은 보호 X

output "db_username" {
  description = "Database administrator username"
  value = aws_db_instance.database.username
  sensitive = true
}

output "db_password" {
  description = "Database administrator psssword"
  value = aws_db_instance.database.password
  sensitive = true
}