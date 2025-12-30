###############################################
# Autoscaling Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "leonow"  # Default for testing
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"  # Default small instance
}

variable "ami_id" {
  description = "AMI ID for the launch template (Ubuntu 22.04 example)"
  type        = string
  default     = "ami-0e86e20dae9224db8"  # Update to your region's Ubuntu 22.04 AMI
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
  description = "ECR repository URL (full URI without tag)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # Default to prevent empty vars
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080  # Default to match app
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 1
}
variable "custom_ami_id" {
  description = "Custom AMI ID with Docker and chatbot pre-baked"
  type        = string
}