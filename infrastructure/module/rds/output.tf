output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.mysql.id
}


output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}


output "db_mysql_address" {
    value = aws_db_instance.mysql.address
  
}


////////// OutPut to use in the null_resource in the Bastion Host provisioner
output "db_mysql_port" {
    value = aws_db_instance.mysql.port
  
}

output "db_mysql_user" {
  value = var.db_user
}

output "db_mysql_password" {
  value = random_password.password.result
}

output "db_mysql_table" {
  value = var.db_name
}


output "rds_credentials_secret_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn
}

output "rds_credentials_secret_name" {
  value = aws_secretsmanager_secret.rds_credentials.name
}
