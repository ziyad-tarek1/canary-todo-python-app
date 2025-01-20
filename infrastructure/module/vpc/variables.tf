
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
}



variable "dns_hostnames_stateus" {
  description = "dns_hostnames_stateus"
  type        = bool
  default     = true
}

variable "dns_support_stateus" {
  description = "dns_support_stateus"
  type        = bool
  default     = true
}

variable "cluster_type" {
  description = "cluster type can be owned or shared"
  type        = string
  default     = "shared"
}


variable "private_subnets" {
  description = "List of private subnet CIDR blocks and AZs"
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks and AZs"
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "create_nat_gateway" {
  description = "Flag to determine if NAT Gateway should be created"
  type        = bool
  default     = true
}
