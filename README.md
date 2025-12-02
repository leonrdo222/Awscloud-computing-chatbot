# AI Chatbot Deployment on AWS (Docker + Terraform)

This project deploys a Python-based AI chatbot to AWS using modern cloud best practices:
- Docker for containerization
- Terraform for infrastructure as code
- GitHub Actions for CI/CD
- Application Load Balancer + HTTPS
- Auto Scaling Group with systemd-managed containers

## Architecture Overview
- VPC with public subnets
- Application Load Balancer (HTTPS via ACM)
- EC2 Auto Scaling Group
- Docker container running Tornado-based chatbot
- Amazon ECR for image storage
- AWS SSM for secure instance management
- Route53 for DNS (`leonow.site`)

## Deployment Flow
1. GitHub Actions builds Docker image
2. Image is pushed to Amazon ECR
3. EC2 instances pull image on boot or restart
4. systemd ensures container restarts on failure/reboot
5. ALB routes traffic to healthy instances

## Prerequisites
- AWS account
- Terraform >= 1.5
- Docker
- GitHub repository with Actions enabled

## How to Deploy
```bash
This project deploys a fully automated **AI-powered chatbot** on **AWS** using **Terraform**, featuring a production-grade, scalable, and secure cloud architecture.

The chatbot is built using:

- **Tornado** – Python web server  
- **NLTK** – Natural Language Processing  
- **Keras + TensorFlow (CPU)** – Deep learning model  
- **Bootstrap** – Frontend interface  

The application is automatically deployed to AWS using:

- **Application Load Balancer (ALB)** with HTTPS  
- **Auto Scaling Group (ASG)**  
- **EC2 Launch Templates**  
- **Amazon Route 53** for domain & DNS  
- **AWS Certificate Manager (ACM)** for SSL  
- **Amazon VPC** with public & private subnets  
- **IAM Roles & Instance Profiles** for EC2  
- **User-data based automated provisioning** of the app  

---

## 🧩 1. Project Overview

### 🎯 Purpose

Deploy an **AI-powered chatbot** to AWS using **100% Infrastructure as Code (IaC)** with Terraform.

The deployment is fully automated:

- EC2 instances launch via Auto Scaling  
- User-data runs on first boot and:
  - Pulls the chatbot **GitHub repository**  
  - Installs Python and all dependencies (TensorFlow, Keras, NLTK, Tornado)  
  - Downloads required **NLTK data**  
  - Starts the Tornado chatbot server (`chatdemo.py`)  
  - Registers instances behind the **ALB target group**  

### 👥 Audience

This project is ideal for:

- **Cloud / DevOps Engineers** learning AWS & Terraform  
- **Developers** deploying Python ML / NLP apps  
- **Students** working on AWS, infrastructure, or AI projects  
- Anyone interested in **scalable, production-style cloud architectures**  

---

## 🏗 2. Architecture
<img width="1538" height="855" alt="AI Chatbot Infrastructure on AWS drawio" src="https://github.com/user-attachments/assets/8fae4fdc-0e6e-4331-8ca7-6aa5afa3a6c0" />


### 🔍 Component Breakdown

#### 🖥 User Interface (UI)

- Users access the chatbot via: **https://leonow.site**  
- The web interface is built with **HTML + Bootstrap** and served by Tornado.

#### ⚙️ Backend

- **Tornado** Python web server  
- AI chatbot logic using **Keras + TensorFlow (CPU)** and **NLTK**  
- Application listens on **port 8080** inside the EC2 instances  
- Managed by **systemd service** (`chatbot.service`) for automatic restarts

#### 🛡 Networking

- **ALB** is deployed in **public subnets**  
- **EC2 instances** run in private / app subnets managed by an **Auto Scaling Group**  
- **Security Groups** restrict traffic:
  - ALB SG: allows inbound **80/443** from the internet  
  - EC2 SG: allows inbound **8080 only from the ALB SG**  
- HTTPS termination at the ALB using **ACM SSL certificate**

#### 📦 Application Code

- Chatbot source code is cloned automatically from a **GitHub repository** during instance bootstrap (via `userdata.sh`)  
- Dependencies installed:
  - **TensorFlow (CPU)**
  - **Keras**
  - **NLTK** (+ `wordnet` and `punkt` corpora)
  - **Tornado**
  - Any extra libraries from `requirements.txt` in the repo  

---

## ⚙️ 3. Prerequisites & Setup

### 🏢 AWS Requirements

You must have:

- An **AWS Account**  
- A **Route 53 Hosted Zone** (e.g. `leonow.site`)  
- IAM permissions (or an admin user) with access to:
  - **EC2**
  - **VPC**
  - **ELB / ALB**
  - **ACM**
  - **Route 53**
  - **IAM**

### 💻 Local Requirements

Install on your local machine:

- **Terraform** `v1.5+`  
- **AWS CLI**  
- **Git**

### 🔍 **Component Breakdown**

#### 🖥 UI
- Accessible via:  
  **https://leonow.site**
- Frontend styled with Bootstrap

#### ⚙️ Backend
- Tornado web server
- Python-based AI chatbot
- Served on port **8080**
- systemd keeps chatbot always running

#### 🛡 Networking
- ALB in **public subnets**
- EC2 instances in **auto-scaling subnets**
- Security groups restrict traffic properly
- HTTPS termination at ALB

#### 📦 Application Code
Cloned automatically from repo:

Dependencies installed:
- TensorFlow CPU  
- Keras  
- NLTK  
- Tornado  
- NLTK wordnet + punkt  

#### deployment guide 
1️⃣ Initialize Terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

2️⃣ Preview the deployment
terraform plan

3️⃣ Apply the infrastructure
terraform apply -auto-approve

Terraform will create:

VPC
Public/Private Subnets
Internet Gateway
NAT Gateway (if included)
Application Load Balancer
Auto Scaling Group
EC2 Launch Template
ACM certificate
Route53 DNS record for leonow.site

##### 5. Administration & Debugging
✔ Check chatbot status
sudo systemctl status chatbot
✔ View application logs
sudo journalctl -u chatbot -n 50 --no-pager
✔ Confirm the app is listening
sudo ss -ltnp | grep 8080
✔ Check ALB health status
curl http://localhost:8080/

#### 6. Scaling

Modify scaling configuration in:
modules/autoscaling/main.tf
Example:
desired_capacity = 2
min_size         = 1
max_size         = 4


The Auto Scaling Group automatically:

Replaces unhealthy EC2 instances
Scales up when CPU load increases
Scales down during low usage

#### 7. Troubleshooting
❌ 504 Gateway Timeout

Cause: EC2 instance failing health checks

Fixes:
Verify chatbot listens on 0.0.0.0:8080
Check systemctl status chatbot
Ensure correct ALB target group port
Fix broken dependencies in userdata

❌ ALB shows “unhealthy targets”

Fix:
Correct health check path (usually /)
Confirm Tornado app started successfully

❌ TensorFlow killed during installation

Fix:
Use CPU-only TensorFlow
Add swap file if needed
Install dependencies BEFORE TensorFlow

❌ User data failed

Fix:
Reorder package installation
Add error logs
Ensure GitHub repo reachable

#### 8. Repository Structure
terraform_chatbotleo/
│
├── main.tf
├── variables.tf
├── backend.tf
│
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── autoscaling/
│   ├── iam/
│   ├── security_groups/
│
└── scripts/
    └── userdata.sh

#### 9. Cleanup (Avoid AWS Charges)

To remove everything:

terraform destroy -auto-approve

This deletes:

EC2 instances
VPC
ALB
IAM roles
Route53 records
ACM certificates
Auto Scaling Group

### 10. Author

Leonardo
GitHub: https://github.com/leonrdo222

Project deployed at:

 🌐 https://leonow.site
