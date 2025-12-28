#!/bin/bash
set -euxo pipefail

exec > /var/log/user-data.log 2>&1

echo "Starting user-data at $(date)"

AWS_REGION="${AWS_REGION}"
ECR_REPO="${ECR_REPO}"
APP_PORT="${APP_PORT}"

IMAGE="$${ECR_REPO}:latest"
CONTAINER_NAME="chatbot"

###############################################
# Base packages
###############################################
apt-get update -y
apt-get install -y ca-certificates curl awscli

###############################################
# Install Docker
###############################################
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

systemctl enable docker
systemctl start docker

###############################################
# Wait for Docker
###############################################
until docker info >/dev/null 2>&1; do
  sleep 2
done

###############################################
# Login to ECR (ESCAPED!)
###############################################
aws ecr get-login-password --region "$${AWS_REGION}" \
  | docker login --username AWS --password-stdin "$${ECR_REPO%/*}"

###############################################
# Pull & run container
###############################################
docker pull "$${IMAGE}"

docker rm -f "$${CONTAINER_NAME}" || true

docker run -d \
  --name "$${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "$${APP_PORT}:8080" \
  "$${IMAGE}"

###############################################
# Verify
###############################################
sleep 10
docker ps
curl -f http://localhost:$${APP_PORT}

echo "User-data completed successfully at $(date)"
