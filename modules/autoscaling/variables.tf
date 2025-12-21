###############################################
# Autoscaling Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the launch template"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for Auto Scaling Group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR repository URL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
}
