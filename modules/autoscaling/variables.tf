variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "ec2_sg_id" {
  type        = string
  description = "Security group ID for EC2 instances"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2"
}

variable "github_repo_url" {
  type        = string
  description = "GitHub repository URL for chatbot app"
}

variable "app_port" {
  type        = number
  description = "App port"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ASG"
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN"
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 2
}

variable "desired_capacity" {
  type        = number
  default     = 1
}
