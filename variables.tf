variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "chatbotleo"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR for private subnet A"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for private subnet B"
  type        = string
  default     = "10.0.4.0/24"
}

variable "az_1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}
