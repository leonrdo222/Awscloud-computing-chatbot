#!/bin/bash
set -e

###############################################
# Terraform-injected variables
###############################################
ECR_REPO="{{ECR_REPO}}"
AWS_REGION="{{AWS_REGION}}"
APP_PORT="{{APP_PORT}}"

IMAGE="${ECR_REPO}:latest"
CONTAINER_NAME="chatbot"

###############################################
# Base system setup (Ubuntu)
###############################################
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  awscli

###############################################
# Install Docker (idempotent)
###############################################
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

systemctl enable docker
systemctl start docker

###############################################
# Wait for Docker daemon
###############################################
until docker info >/dev/null 2>&1; do
  sleep 2
done

###############################################
# Login to Amazon ECR
###############################################
ECR_REGISTRY="$(echo "$ECR_REPO" | cut -d/ -f1)"

aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY"

###############################################
# Pull latest image
###############################################
docker pull "$IMAGE"

###############################################
# Stop old container (if exists)
###############################################
docker rm -f "$CONTAINER_NAME" || true

###############################################
# Run chatbot container
# chatdemo.py listens on 0.0.0.0:8080
###############################################
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p "$APP_PORT:8080" \
  "$IMAGE"
