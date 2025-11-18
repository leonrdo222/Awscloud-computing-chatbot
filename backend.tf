terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-chatbot"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}
