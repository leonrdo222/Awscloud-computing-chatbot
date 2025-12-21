#!/bin/bash
set -e

###############################################
# Terraform-injected variables
###############################################
ECR_REPO="${ECR_REPO}"
AWS_REGION="${AWS_REGION}"
APP_PORT="${APP_PORT}"

###############################################
# Install base dependencies
###############################################
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  awscli

###############################################
# Install Docker
###############################################
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable docker
  systemctl start docker
fi

###############################################
# Login to ECR and pull image
###############################################
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ECR_REPO}"

docker pull "${ECR_REPO}:latest"

###############################################
# Run chatbot container
###############################################
docker rm -f chatbot || true

docker run -d \
  --name chatbot \
  --restart unless-stopped \
  -p "${APP_PORT}:8080" \
  "${ECR_REPO}:latest"
