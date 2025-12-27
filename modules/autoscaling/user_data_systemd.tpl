#!/bin/bash

# Log everything to /var/log/user-data.log for debugging
exec > /var/log/user-data.log 2>&1
set -x  # Enable command tracing

echo "Starting user-data script at $(date)"

# Update system packages
apt update -y
apt upgrade -y

# Remove any conflicting snap Docker installation
snap remove docker || true  # Ignore if not installed

# Uninstall old Docker versions (apt-based)
apt remove -y docker docker.io containerd runc docker-doc docker-compose docker-compose-v2 podman-docker || true

# Install prerequisites for Docker repo setup + AWS CLI
apt install -y ca-certificates curl gnupg lsb-release awscli

# Set up Docker's official APT repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y

# Install Docker Engine and related packages
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Wait for Docker to be ready (up to 60s)
for i in {1..12}; do
  if docker version; then
    break
  fi
  echo "Waiting for Docker to start... ($i/12)"
  sleep 5
done

# Add ubuntu user to docker group for non-root access
usermod -aG docker ubuntu

# Login to ECR (using IAM role for credentials)
aws ecr get-login-password --region $${AWS_REGION} | docker login --username AWS --password-stdin $${ECR_REPO%/*}

# Pull the latest image from ECR
docker pull $${ECR_REPO}:latest

# Create systemd unit file for the chatbot container
cat <<EOF > /etc/systemd/system/chatbot.service
[Unit]
Description=Leonow Chatbot Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm --name chatbot -p $${APP_PORT}:8080 $${ECR_REPO}:latest
ExecStop=/usr/bin/docker stop chatbot

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
systemctl daemon-reload
systemctl enable chatbot.service
systemctl start chatbot.service

# Wait for container to start and verify
sleep 10
docker ps  # Log running containers
curl -v http://localhost:$${APP_PORT} || echo "Curl failed, check logs"

echo "User-data script completed at $(date)"