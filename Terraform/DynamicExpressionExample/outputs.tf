output "first_tags" {
  value = aws_instance.ubuntu[0].tags
}

# splat expression으로 여러개의 리소스를 모두 선택 및 지정
output "private_addresses" {
  value = aws_instance.ubuntu[*].private_dns  
}