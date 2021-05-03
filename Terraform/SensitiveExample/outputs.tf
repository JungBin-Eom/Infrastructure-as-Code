# Output declarations

# sensitive data가 output에 그냥 정의되면 error
# output에 sensitive=true 추가하면 (sensitive value) 라고 보여주고 값은 state에 plain text로 저장
output "db_connect_string" {
  description = "MySQL database connection string"
  value = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
  sensitive = true
}