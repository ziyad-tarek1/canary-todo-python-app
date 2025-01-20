resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}


resource "aws_db_instance" "mysql" {
  allocated_storage       = var.db_allocated_storage
  engine                  = var.engine_type
  engine_version          = var.db_version
  instance_class          = var.db_instance_class
  username                = var.db_user
  password                = random_password.password.result //var.db_password
  port                    = var.db_port
  publicly_accessible     = var.accessible
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = var.snapshot_policy
  backup_retention_period = 0
  deletion_protection     = var.deletion_policy

  tags = {
    Name = "${var.project_name}-rds-mysql"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Security Group for RDS MySQL DB"
  vpc_id      = var.vpc_id

  # Allow MySQL traffic from EKS Nodes SG
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.eks-sg
  }

  # Open ingress for testing purposes
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Testing only
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}


# Create a Secret manager to store the RDS credentials.
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%"
}

# Create Secrets Manager for storing RDS credentials
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.project_name}-rds-credentials4"   //// remember to change it ///////
  description = "Credentials for the RDS MySQL Database"
}

# Store username and password in the Secrets Manager secret
resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    "username" : var.db_user,
    "password" : random_password.password.result,
    "endpointurl" : aws_db_instance.mysql.address
    "db_name"     : var.db_name
  })
}

/*
//Testing Create a VPC endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = var.vpc_id                    # Pass the VPC ID from your RDS module inputs
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  subnet_ids        = var.private_subnets           # Use the private subnets
  security_group_ids = [aws_security_group.rds_sg.id] # Replace with the RDS security group or a dedicated one

  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-secretsmanager-endpoint"
    Environment = var.environment
  }
}
*/

// To use the below provisioner insted of the Bastion Host you will need to make your RDS DB in a public subnet and to change the publicly_accessible to true
/*resource "null_resource" "create_database" {
  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.mysql.address} \
            -P ${aws_db_instance.mysql.port} \
            -u ${var.db_user} -p"${random_password.password.result}" \
            -e "CREATE DATABASE IF NOT EXISTS ${var.db_name};"
    EOT
  }

  # Ensure it runs after the RDS instance is created
  depends_on = [aws_db_instance.mysql]
}


resource "null_resource" "create_table" {
  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.mysql.address} \
            -P ${aws_db_instance.mysql.port} \
            -u ${var.db_user} -p"${random_password.password.result}" \
            ${var.db_name} < "/home/ziad/Templates/infrastructure/module/rds/create_table.sql"
    EOT
  }

  # Ensure it runs after RDS is created
  depends_on = [aws_db_instance.mysql , null_resource.create_database]
}
*/
