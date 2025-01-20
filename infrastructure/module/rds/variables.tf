variable "db_name" {
  default = "exampledb"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "your-secure-password"
}

variable "db_instance_class" {
  default = "db.t3.micro" # Small instance for testing
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_port" {
  default = 3306
}

variable "project_name" {
  
}
variable "vpc_id" {
  
}
variable "private_subnets" {
  
}

variable "engine_type" {
  
}
variable "db_version" {
  
}

variable "eks-sg" {
  description = "List of security group IDs for EKS nodes"
  type        = list(string)
}

variable "accessible" {
    type = bool
  
}

variable "deletion_policy" {
    type = bool
  
}

variable "snapshot_policy" {
    type = bool
  
}