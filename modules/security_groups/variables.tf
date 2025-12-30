###############################################
# Security Groups Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix for security groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block (used to restrict SSM access)"
  type        = string
}

variable "app_port" {
  description = "Port the chatbot application listens on"
  type        = number
  default     = 8080
}

variable "admin_cidr" {
  description = "CIDR block allowed for SSH access (use your IP or VPC CIDR)"
  type        = string
  default     = "0.0.0.0/0"  # WARNING: Restrict this in production!
}