###############################################
# VPC Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix for VPC resources"
  type        = string
}

# ---------- VPC ----------
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# ---------- PUBLIC SUBNETS ----------
variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet AZ1"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR block for Public Subnet AZ2"
  type        = string
}

# ---------- PRIVATE SUBNETS ----------
variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet AZ1"
  type        = string
}

variable "private_subnet2_cidr" {
  description = "CIDR block for Private Subnet AZ2"
  type        = string
}

# ---------- AVAILABILITY ZONES ----------
variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}
