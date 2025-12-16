#!/bin/bash
set -e

###############################################
# Base system setup (Ubuntu)
###############################################
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  jq \
  unzip \
  awscli

###############################################
# Docker installation
###############################################
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable docker
  systemctl start docker
fi

###############################################
# Install SSM Agent
###############################################
if ! systemctl is-active --quiet amazon-ssm-agent; then
  curl -o /tmp/ssm.deb https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
  dpkg -i /tmp/ssm.deb || apt-get install -f -y
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
fi

###############################################
# Terraform-injected variables
###############################################
ECR_REPO="${ECR_REPO}"
AWS_REGION="${AWS_REGION}"
APP_PORT="${APP_PORT}"
MODEL_S3_URI="${MODEL_S3_URI}"

IMAGE="$${ECR_REPO}:latest"
CONTAINER_NAME="chatbot"

###############################################
# App runner script (systemd target)
###############################################
cat >/usr/local/bin/run-chatbot.sh <<'RUNEOF'
#!/bin/bash
set -e

aws ecr get-login-password --region $${AWS_REGION} \
  | docker login --username AWS --password-stdin $${ECR_REPO%/*}

docker pull $${IMAGE}

mkdir -p /app/data

if [ -n "$${MODEL_S3_URI}" ]; then
  TMP="/tmp/model.zip"
  aws s3 cp "$${MODEL_S3_URI}" "$${TMP}"
  unzip -o "$${TMP}" -d /app/data
  rm -f "$${TMP}"
fi

docker rm -f chatbot || true

docker run -d \
  --name chatbot \
  --restart unless-stopped \
  -p $${APP_PORT}:8080 \
  $${IMAGE}
RUNEOF

chmod +x /usr/local/bin/run-chatbot.sh

###############################################
# systemd service
###############################################
cat >/etc/systemd/system/chatbot.service <<'EOF'
[Unit]
Description=Chatbot Docker Service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/run-chatbot.sh
ExecStop=/usr/bin/docker rm -f chatbot
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable chatbot
systemctl start chatbot
