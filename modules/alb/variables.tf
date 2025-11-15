variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "ALB security group ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name (e.g. leonow.site)"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}

variable "app_port" {
  type        = number
  description = "App port used by target group"
}
