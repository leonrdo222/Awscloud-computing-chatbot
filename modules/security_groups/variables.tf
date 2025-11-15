variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for security groups"
}

variable "app_port" {
  type        = number
  description = "Application port for EC2 instances"
}
