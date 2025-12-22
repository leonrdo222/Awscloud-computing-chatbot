# -------------------------------
# Chatbot Docker Image
# -------------------------------
FROM python:3.11-slim

# Prevent Python buffering issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Working directory
WORKDIR /app

# System dependencies required by NLP / ML libs
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

# App configuration
ENV HOST=0.0.0.0
ENV PORT=8080

# Expose Tornado port
EXPOSE 8080

# Run chatbot
CMD ["python", "chatdemo.py"]
