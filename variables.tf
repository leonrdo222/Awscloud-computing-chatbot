###############################################
# Root Variables
###############################################

# ------------ Project ------------
variable "project_name" {
  type    = string
  default = "chatbotleo"
}

# ------------ VPC ------------
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
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

# ------------ Application ------------
variable "app_port" {
  type    = number
  default = 8080
}

# ------------ Autoscaling / EC2 ------------
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
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

variable "github_repo_url" {
  type = string
}

# ------------ Domain / Route53 / ACM ------------
variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
