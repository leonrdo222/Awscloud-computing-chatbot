# packer/leonow-chatbot.pkr.hcl
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"  # Change if your project uses another region
}

variable "ecr_repo_url" {
  type        = string
  description = "Full ECR repository URL (e.g., 123456789012.dkr.ecr.us-east-1.amazonaws.com/leonow-chatbot)"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

source "amazon-ebs" "leonow_chatbot" {
  region         = var.region
  instance_type  = "t3.micro"
  ssh_username   = "ubuntu"
  ami_name       = "leonow-chatbot-{{timestamp}}"
  ami_description = "Ubuntu 22.04 with Docker and leonow-chatbot pre-installed"

  # Base Ubuntu 22.04 AMI (official, updated regularly)
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]  # Canonical
  }

  # Use the same VPC/subnet as your project for build access to ECR
  subnet_id              = "subnet-CHANGE_ME"  # Replace with one of your public subnets
  vpc_id                 = "vpc-CHANGE_ME"     # Optional, Packer can infer from subnet
  associate_public_ip_address = true

  tags = {
    Name    = "leonow-chatbot-base"
    Project = "leonow"
  }
}

build {
  sources = ["source.amazon-ebs.leonow_chatbot"]

  provisioner "shell" {
    inline = [
      "echo '=== Updating system ==='",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",

      "echo '=== Installing Docker ==='",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",

      "echo '=== Logging into ECR ==='",
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_repo_url}",

      "echo '=== Pulling chatbot image ==='",
      "docker pull ${var.ecr_repo_url}:${var.image_tag}",

      "echo '=== Creating systemd service ==='",
      "sudo tee /etc/systemd/system/chatbot.service > /dev/null <<EOF",
      "[Unit]",
      "Description=Leonow Chatbot Container",
      "After=docker.service",
      "Requires=docker.service",
      "",
      "[Service]",
      "Restart=always",
      "ExecStart=/usr/bin/docker run --name chatbot -p 8080:8080 ${var.ecr_repo_url}:${var.image_tag}",
      "ExecStop=/usr/bin/docker stop chatbot",
      "ExecStopPost=/usr/bin/docker rm chatbot",
      "",
      "[Install]",
      "WantedBy=multi-user.target",
      "EOF",

      "sudo systemctl daemon-reload",
      "sudo systemctl enable chatbot.service",
      "echo '=== AMI baking complete ==='"
    ]
  }
}