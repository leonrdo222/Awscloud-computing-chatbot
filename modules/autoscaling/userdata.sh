#!/bin/bash
# ============================================
# USERDATA: Run Tornado Chatbot using chatdemo.py
# ============================================

exec > >(tee /var/log/userdata.log | logger -t user_data -s 2>/dev/console) 2>&1
echo "===== STARTING USERDATA SCRIPT ====="

APP_PORT=${APP_PORT}

# --- Update & install base packages ---
apt-get update -y
apt-get install -y python3 python3-pip python3-venv git

# --- Clone chatbot repo ---
cd /home/ubuntu
rm -rf cloud-computing-chatbot
git clone ${GITHUB_REPO_URL} cloud-computing-chatbot
cd cloud-computing-chatbot

# --- Python virtual environment ---
python3 -m venv venv
source venv/bin/activate

# --- Install dependencies (CPU safe) ---
pip install --upgrade pip
pip install tornado keras nltk tensorflow-cpu

# If requirements.txt exists, install all EXCEPT tensorflow
if [ -f "requirements.txt" ]; then
  grep -v "tensorflow" requirements.txt > /tmp/req.txt
  pip install -r /tmp/req.txt
fi

# --- Install NLTK data ---
python3 << EOF
import nltk
nltk.download('punkt')
nltk.download('wordnet')
EOF

# --- Ensure pretrained model exists ---
if [ -d "data" ]; then
  echo "Pretrained model directory exists."
else
  echo "No pretrained model found. Running train_chatbot.py..."
  if [ -f "train_chatbot.py" ]; then
    python3 train_chatbot.py || echo "Training failed, continuing..."
  fi
fi

# --- Create systemd service ---
cat <<EOF >/etc/systemd/system/chatbot.service
[Unit]
Description=Tornado Chatbot Server (chatdemo.py)
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/cloud-computing-chatbot
Environment="PATH=/home/ubuntu/cloud-computing-chatbot/venv/bin"
ExecStart=/home/ubuntu/cloud-computing-chatbot/venv/bin/python3 chatdemo.py --port=${APP_PORT}
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# --- Enable and start service ---
systemctl daemon-reload
systemctl enable chatbot
systemctl start chatbot

echo "===== Waiting 10s for startup ====="
sleep 10

# --- Health test ---
curl -v http://localhost:${APP_PORT}/ || true

echo "===== USERDATA COMPLETED ====="
