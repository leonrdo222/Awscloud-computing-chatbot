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
# ECR
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
# Auto Scaling (Golden AMI)
###############################################
module "autoscaling" {
  source = "./modules/autoscaling"

  project_name          = var.project_name
  instance_type         = var.instance_type
  custom_ami_id         = var.custom_ami_id

  ec2_sg_id             = module.security_groups.ec2_sg_id
  instance_profile_name = module.iam.instance_profile_name

  subnet_ids       = module.vpc.public_subnet_ids
  target_group_arn = module.alb.target_group_arn

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
}