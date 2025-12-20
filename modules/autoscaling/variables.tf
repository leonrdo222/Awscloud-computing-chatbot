variable "project_name" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string }

variable "ec2_sg_id" { type = string }
variable "instance_profile_name" { type = string }

variable "subnet_ids" { type = list(string) }
variable "target_group_arn" { type = string }

variable "ecr_repo_url" { type = string }
variable "aws_region" { type = string }
variable "app_port" { type = number }
variable "model_s3_uri" { type = string }

variable "min_size" { type = number }
variable "max_size" { type = number }
variable "desired_capacity" { type = number }
