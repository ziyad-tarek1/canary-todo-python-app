# Generate an RSA private key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair for SSH access
resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

# Save the private key locally
resource "local_file" "bastion_private_key" {
  content          = tls_private_key.rsa_4096.private_key_pem
  filename         = "./${var.key_name}.pem"
  file_permission  = "0400"
}

# Fetch the latest Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-bastion-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

// this access if only for test perpous remove it in production
resource "aws_iam_role_policy_attachment" "eks_AdministratorAccess_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Security Group for EC2 Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security Group for the Bastion Host"
  vpc_id      = var.vpc_id

  # SSH access (allowing from any IP temporarily for testing)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access for testing purposes (remove in production)
  ingress {
    description = "Allow all ports for testing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}


# EC2 Instance with Key Pair and Provisioners
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = aws_key_pair.bastion_key.key_name

  # User Data for Instance Bootstrapping
  user_data = file(var.entry_point_script)

  # Connection for SSH Provisioning
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa_4096.private_key_pem
  }

  # File Provisioner
  provisioner "file" {
    source      = var.provisioner_script
    destination = "/home/ubuntu/${basename(var.provisioner_script)}"
  }

  # Remote-Exec Provisioner
  provisioner "remote-exec" {
    script = var.provisioner_script
  }

  provisioner "file" {
    source      = var.create_table_sql_path
    destination = "/home/ubuntu/create_table.sql"
  }

provisioner "remote-exec" {
  inline = [
    "sudo apt-get update && sudo apt-get install -y mysql-client",
 /*   "kubectl create secret -n $namespace generic rds-endpoint --from-literal=endpoint=$rds_endpoint || true
kubectl create secret -n $namespace generic rds-username --from-literal=username=$db_username || true
kubectl create secret -n $namespace generic rds-password --from-literal=password=$db_password ",*/
    "mysql -h ${var.rds_endpoint} \\",
    "      -P ${var.rds_port} \\",
    "      -u ${var.rds_user} -p\"${var.rds_password}\" \\",
    "      -e \"CREATE DATABASE IF NOT EXISTS ${var.rds_db_name};\"",
    "mysql -h ${var.rds_endpoint} \\",
    "      -P ${var.rds_port} \\",
    "      -u ${var.rds_user} -p\"${var.rds_password}\" \\",
    "      ${var.rds_db_name} < /home/ubuntu/create_table.sql"
  ]
}

  tags = {
    Name = "${var.project_name}_bastion"
  }

  depends_on = [var.eks_dependency]
}

# Elastic IP for EC2 Instance
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id  

  tags = {
    Name = "${var.project_name}-bastion-eip"
  }
}