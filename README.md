# AI Chatbot Deployment on AWS (Docker + Terraform)

This project deploys a Python-based AI chatbot to AWS using modern cloud best practices:
- Docker for containerization
- Terraform for infrastructure as code
- GitHub Actions for CI/CD
- Application Load Balancer + HTTPS
- Auto Scaling Group with systemd-managed containers

## Architecture Overview
- VPC with public subnets
- Application Load Balancer (HTTPS via ACM)
- EC2 Auto Scaling Group
- Docker container running Tornado-based chatbot
- Amazon ECR for image storage
- AWS SSM for secure instance management
- Route53 for DNS (`leonow.site`)

## Deployment Flow
1. GitHub Actions builds Docker image
2. Image is pushed to Amazon ECR
3. EC2 instances pull image on boot or restart
4. systemd ensures container restarts on failure/reboot
5. ALB routes traffic to healthy instances

## Prerequisites
- AWS account
- Terraform >= 1.5
- Docker
- GitHub repository with Actions enabled

## How to Deploy
```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
