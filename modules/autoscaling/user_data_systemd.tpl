#!/bin/bash

# Full logging for debugging
exec > /var/log/user-data.log 2>&1
set -x

echo "User-data started at $(date)"

# Fail fast if variables are missing
if [ -z "${ECR_REPO}" ] || [ -z "${AWS_REGION}" ] || [ -z "${APP_PORT}" ]; then
  echo "ERROR: Missing required variables (ECR_REPO, AWS_REGION, or APP_PORT)" >&2
  exit 1
fi

# Update system
DEBIAN_FRONTEND=noninteractive apt update -y
DEBIAN_FRONTEND=noninteractive apt upgrade -y

# Remove conflicting snap Docker
snap remove docker || true

# Install prerequisites + AWS CLI
apt install -y ca-certificates curl gnupg lsb-release awscli

# Add official Docker repo
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y

# Install Docker
DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
systemctl start docker
systemctl enable docker

# Wait for Docker to be ready
for i in {1..30}; do
  if docker version &> /dev/null; then
    echo "Docker is ready"
    break
  fi
  sleep 2
done

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO%/*}

# Pull the latest image
docker pull ${ECR_REPO}:latest

# Create systemd service
cat > /etc/systemd/system/chatbot.service <<EOF
[Unit]
Description=Leonow Chatbot Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name chatbot -p ${APP_PORT}:8080 ${ECR_REPO}:latest
ExecStop=/usr/bin/docker stop chatbot
ExecStopPost=/usr/bin/docker rm chatbot

[Install]
WantedBy=multi-user.target
EOF

# Start the service
systemctl daemon-reload
systemctl enable chatbot.service
systemctl start chatbot.service

echo "User-data completed successfully at $(date)"