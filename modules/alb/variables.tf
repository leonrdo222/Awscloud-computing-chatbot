###############################################
# ALB Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix used for ALB resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., leonow.site)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
}

variable "app_port" {
  description = "Port the application listens on inside EC2 instances"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/"
}