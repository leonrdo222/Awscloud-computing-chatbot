#!/bin/bash
set -eux

# Log everything
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

###############################################
# Variables from Terraform
###############################################
ECR_REPO="${ECR_REPO}"
AWS_REGION="${AWS_REGION}"
APP_PORT="${APP_PORT}"

IMAGE="${ECR_REPO}:latest"
CONTAINER_NAME="chatbot"

###############################################
# Base packages
###############################################
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  awscli

###############################################
# Install Docker (OFFICIAL WAY)
###############################################
curl -fsSL https://get.docker.com | sh

systemctl daemon-reexec
systemctl enable docker
systemctl start docker

###############################################
# Wait for Docker
###############################################
until systemctl is-active --quiet docker; do
  sleep 2
done

###############################################
# Login to ECR (NON-INTERACTIVE)
###############################################
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ECR_REPO%/*}"

###############################################
# Pull image
###############################################
docker pull "${IMAGE}"

###############################################
# Run chatbot container
###############################################
docker rm -f "${CONTAINER_NAME}" || true

docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${APP_PORT}:8080" \
  "${IMAGE}"
