#!/bin/bash

# Log everything to /var/log/user-data.log for debugging
exec > /var/log/user-data.log 2>&1
set -x  # Enable command tracing

echo "Starting user-data script at $(date)"

# Variable validation (fail early if empty)
if [ -z "$${AWS_REGION}" ]; then
  echo "Error: AWS_REGION is empty or not set" >&2
  exit 1
fi
if [ -z "$${ECR_REPO}" ]; then
  echo "Error: ECR_REPO is empty or not set" >&2
  exit 1
fi
if [ -z "$${APP_PORT}" ]; then
  echo "Error: APP_PORT is empty or not set" >&2
  exit 1
fi

# Update system packages non-interactively
DEBIAN_FRONTEND=noninteractive apt update -y
DEBIAN_FRONTEND=noninteractive apt upgrade -y

# Remove any conflicting snap Docker installation
snap remove docker || true  # Ignore if not installed

# Uninstall old Docker versions (apt-based)
apt remove -y docker docker.io containerd runc docker-doc docker-compose docker-compose-v2 podman-docker || true
apt autoremove -y

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
DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Wait for Docker to be ready (up to 60s)
for i in {1..12}; do
  if docker version > /dev/null 2>&1; then
    break
  fi
  echo "Waiting for Docker to start... ($i/12)"
  sleep 5
done
if ! docker version > /dev/null 2>&1; then
  echo "Docker failed to start after 60s" >&2
  exit 1
fi

# Add ubuntu user to docker group for non-root access
usermod -aG docker ubuntu

# Login to ECR (using IAM role for credentials) with error handling
LOGIN_PASSWORD=$(aws ecr get-login-password --region $${AWS_REGION}) || { echo "Failed to get ECR login password" >&2; exit 1; }
echo "$LOGIN_PASSWORD" | docker login --username AWS --password-stdin $${ECR_REPO%/*} || { echo "Docker ECR login failed" >&2; exit 1; }

# Pull the latest image from ECR with error handling
docker pull $${ECR_REPO}:latest || { echo "Failed to pull image from ECR" >&2; exit 1; }

# Create systemd unit file for the chatbot container
cat <<EOF > /etc/systemd/system/chatbot.service
[Unit]
Description=Leonow Chatbot Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name chatbot -p $${APP_PORT}:8080 $${ECR_REPO}:latest
ExecStop=/usr/bin/docker stop chatbot
ExecStopPost=/usr/bin/docker rm chatbot

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
systemctl daemon-reload
systemctl enable chatbot.service
systemctl start chatbot.service

# Wait for container to start and verify (extended wait if needed)
sleep 20
docker ps  # Log running containers
curl -v http://localhost:$${APP_PORT} || echo "Curl failed, check logs"

# Additional check: Container status
systemctl status chatbot.service

echo "User-data script completed at $(date)"