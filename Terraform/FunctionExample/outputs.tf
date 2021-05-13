output "web_public_address" {
  value = "${aws_instance.web.public_ip}:8080"
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "ami_value" {
  value = lookup(var.aws_amis, var.aws_region)
}

# 두개의 security group id가 하나의 리스트로 함께 나오도록 concat 함수 사용
output "web_security_group_ids" {
  value = concat([aws_security_group.sg_22.id, aws_security_group.sg_8080.id])
}