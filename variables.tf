###############################################
# Root Variables
###############################################

###############################################
# Project / AWS
###############################################
variable "project_name" {
  description = "Project name prefix used for all resources"
  type        = string
  default     = "chatbotleo"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

###############################################
# VPC / Networking
###############################################
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}
variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}

###############################################
# Security
###############################################
variable "admin_cidr" {
  description = "CIDR allowed to SSH into EC2 instances"
  type        = string
  default     = "0.0.0.0/0"
}

###############################################
# Application / ALB
###############################################
variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/"
}

###############################################
# Domain / Route53
###############################################
variable "domain_name" {
  description = "Domain name managed in Route53"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
}

###############################################
# EC2 / Auto Scaling
###############################################
variable "instance_type" {
  description = "EC2 instance type for Auto Scaling Group"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID used by the launch template"
  type        = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}
