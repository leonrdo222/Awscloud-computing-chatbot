variable "project_name" {
  description = "Prefix for resource naming"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Primary AWS Availability Zone"
  type        = string
}

variable "availability_zone2" {
  description = "Secondary AWS Availability Zone"
  type        = string
}
