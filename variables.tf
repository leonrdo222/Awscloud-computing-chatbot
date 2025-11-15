variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "chatbotleo"
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Primary Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone2" {
  description = "Secondary Availability Zone"
  type        = string
  default     = "us-east-1b"
}

variable "domain_name" {
  description = "Root domain name for Route53 and ACM"
  type        = string
  default     = "leonow.site"
}

variable "hosted_zone_id" {
  description = "Existing Route53 hosted zone ID for the domain"
  type        = string
  default     = "Z05809061MJKQBOYTNYKF"
}

variable "instance_type" {
  description = "EC2 instance type for the chatbot"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "leo-key"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "github_repo_url" {
  description = "GitHub repository URL for the chatbot application"
  type        = string
  default     = "https://github.com/edwincai/cloud-computing-chatbot.git"
}

variable "app_port" {
  description = "Port that the chatbot web app listens on"
  type        = number
  default     = 8080
}
