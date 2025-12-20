###############################################
# Global
###############################################
<<<<<<< HEAD

# ------------ Project / AWS ------------
variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "chatbotleo"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# ------------ VPC / Networking ------------
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}

# ------------ Security ------------
variable "admin_cidr" {
  description = "CIDR allowed to SSH into EC2 instances"
  type        = string
  default     = "0.0.0.0/0"
}

# ------------ Application ------------
variable "app_port" {
  description = "Application port exposed by container"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/"
}

# ------------ Domain / Route53 / ACM ------------
variable "domain_name" {
  description = "Domain name (Route53)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}

# ------------ Autoscaling / EC2 ------------
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name (optional)"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

# ------------ CI / Source ------------
variable "github_repo_url" {
  description = "GitHub repo URL (used by CI or metadata)"
  type        = string
  default     = ""
}

# ------------ Model Artifacts (Optional) ------------
variable "model_s3_uri" {
  description = "Optional S3 URI for ML model artifacts"
  type        = string
=======
variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

###############################################
# Networking / VPC
###############################################
variable "vpc_cidr_block" { type = string }

variable "public_subnet_cidr" { type = string }
variable "public_subnet2_cidr" { type = string }
variable "private_subnet_cidr" { type = string }
variable "private_subnet2_cidr" { type = string }

variable "availability_zone_1" { type = string }
variable "availability_zone_2" { type = string }

###############################################
# Security
###############################################
variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to SSH into EC2"
}

###############################################
# Application / DNS
###############################################
variable "domain_name" { type = string }
variable "hosted_zone_id" { type = string }

variable "app_port" {
  type        = number
  description = "Container listening port"
}

variable "health_check_path" {
  type        = string
  description = "ALB health check path"
}

###############################################
# EC2 / Autoscaling
###############################################
variable "instance_type" { type = string }
variable "ami_id" { type = string }

variable "min_size" { type = number }
variable "max_size" { type = number }
variable "desired_capacity" { type = number }

###############################################
# Model Artifacts
###############################################
variable "model_s3_uri" {
  type        = string
  description = "Optional S3 URI for pretrained model"
>>>>>>> b4adddb (added working files)
  default     = ""
}

variable "model_s3_arns" {
<<<<<<< HEAD
  description = "List of S3 ARNs EC2 is allowed to read"
  type        = list(string)
  default     = []
=======
  type        = list(string)
  description = "S3 ARNs EC2 is allowed to read"
>>>>>>> b4adddb (added working files)
}
