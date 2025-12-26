# -------------------------------
# Chatbot Docker Image
# -------------------------------
FROM python:3.11-slim

# Prevent Python buffering issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Working directory
WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    curl \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
  && rm -rf /var/lib/apt/lists/*

# Install Python dependencies first (cache-friendly)
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Download required NLTK data at build time
RUN python - <<'EOF'
import nltk
nltk.download('punkt')
nltk.download('wordnet')
EOF

# Copy application code
COPY . .

# Expose Tornado port (matches chatdemo.py default)
EXPOSE 8080

# Run chatbot (foreground process)
CMD ["python", "chatdemo.py"]
