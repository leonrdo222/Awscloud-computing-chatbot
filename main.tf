###############################################
# Root Infrastructure for leonow.site
###############################################

###############################################
# VPC
###############################################
module "vpc" {
  source = "./modules/vpc"

  project_name   = var.project_name
  vpc_cidr_block = var.vpc_cidr_block

  public_subnet_cidr  = var.public_subnet_cidr
  public_subnet2_cidr = var.public_subnet2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}

###############################################
# Security Groups
###############################################
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr_block
  app_port     = var.app_port
  admin_cidr   = var.admin_cidr
}

###############################################
# IAM (EC2 + SSM + ECR)
###############################################
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

###############################################
# ECR (needed for GitHub Actions / CI/CD to push images)
###############################################
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

###############################################
# ALB + Route53 + ACM
###############################################
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id

  domain_name       = var.domain_name
  hosted_zone_id    = var.hosted_zone_id
  app_port          = var.app_port
  health_check_path = var.health_check_path
}

###############################################
# Autoscaling Module Variables (Golden AMI Version)
###############################################

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "custom_ami_id" {
  description = "Custom AMI ID with Docker and chatbot pre-baked (from Packer)"
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
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}