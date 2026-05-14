# DevOps Deployment Guide

Complete guide to deploy this Node.js app using Docker, Nginx, and GitHub Actions CI/CD.

## Architecture Overview

```
GitHub Repository
        ↓
GitHub Actions (CI/CD on push to main)
        ↓
SSH into AWS EC2 / GCP VM
        ↓
Pull latest code
        ↓
Docker Build & Run
        ↓
Nginx Reverse Proxy (Port 80 → 3000)
        ↓
Public Website (http://your-ip)
```

---

## Prerequisites

- GitHub account and repository
- AWS EC2 or GCP Compute Engine instance (Ubuntu 20.04+)
- SSH key pair for accessing the server
- Basic Linux command-line knowledge

---

## Step 1: Prepare Your Linux Server

### 1.1 Launch VM Instance
- **AWS EC2**: Choose Ubuntu 20.04 LTS, t3.micro (free tier eligible)
- **GCP Compute Engine**: Choose Ubuntu 20.04 LTS, e2-micro

### 1.2 SSH into Your Server
```bash
ssh -i /path/to/private-key.pem ubuntu@YOUR_SERVER_IP
```

### 1.3 Update System & Install Dependencies
```bash
sudo apt update
sudo apt upgrade -y

# Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu

# Install Nginx
sudo apt install nginx -y

# Install Git
sudo apt install git -y

# Logout and login again for docker group to take effect
exit
ssh -i /path/to/private-key.pem ubuntu@YOUR_SERVER_IP
```

### 1.4 Verify Installation
```bash
docker --version
nginx -v
git --version
```

---

## Step 2: Configure Nginx Reverse Proxy

### 2.1 Create Nginx Configuration
```bash
sudo nano /etc/nginx/sites-available/default
```

Replace the entire file with the content from `nginx.conf` in this repository:

```nginx
server {
    listen 80;
    listen [::]:80;
    
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
    
    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
```

### 2.2 Test & Enable Nginx
```bash
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx
```

---

## Step 3: Deploy App Manually (First Time)

### 3.1 Clone Repository
```bash
mkdir -p ~/devops-app
cd ~/devops-app
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git .
```

### 3.2 Build Docker Image
```bash
docker build -t devops-app:latest .
```

### 3.3 Run Container
```bash
docker run -d \
  --name devops-app \
  --restart unless-stopped \
  -p 3000:3000 \
  devops-app:latest
```

### 3.4 Verify Deployment
```bash
# Check running containers
docker ps

# Check logs
docker logs devops-app

# Test the app
curl http://localhost:3000
curl http://your-public-ip
```

---

## Step 4: Setup GitHub Actions CI/CD

### 4.1 Generate SSH Key (If not already done)
On your local machine:
```bash
ssh-keygen -t rsa -b 4096 -f devops-key -N ""
```

### 4.2 Add SSH Public Key to Server
```bash
# On your server
mkdir -p ~/.ssh
# Then paste the contents of devops-key.pub

# Or from your local machine:
ssh-copy-id -i devops-key.pub -o StrictHostKeyChecking=no ubuntu@YOUR_SERVER_IP
```

### 4.3 Add GitHub Secrets
In your GitHub repository:
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**

Add these secrets:
- **SERVER_IP**: Your server's public IP address
- **SERVER_USER**: `ubuntu`
- **SSH_KEY**: Contents of your private key (devops-key)

### 4.4 Verify Workflow
The `.github/workflows/deploy.yml` file is already configured. It will:
- Trigger on push to `main` branch
- Connect to your server via SSH
- Pull latest code
- Build Docker image
- Stop old container
- Start new container
- Verify deployment success

---

## Step 5: Testing the Deployment

### 5.1 Manual Test
```bash
curl http://YOUR_SERVER_IP
curl http://YOUR_SERVER_IP/health
curl http://YOUR_SERVER_IP/api/info
```

### 5.2 Push Code to Trigger Deployment
```bash
git add .
git commit -m "Deploy DevOps app"
git push origin main
```

Go to GitHub **Actions** tab to watch the workflow execute.

---

## Step 6: Monitoring & Maintenance

### 6.1 View Logs
```bash
# Docker logs
docker logs devops-app
docker logs -f devops-app  # Follow logs

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Docker stats
docker stats devops-app
```

### 6.2 Restart Services
```bash
# Restart Docker container
docker restart devops-app

# Restart Nginx
sudo systemctl restart nginx

# Check service status
docker ps
sudo systemctl status nginx
```

### 6.3 Update Application
Simply push to main branch - GitHub Actions will handle deployment:
```bash
git add .
git commit -m "Update app"
git push origin main
```

---

## Step 7: SSL/HTTPS Setup (Optional)

### 7.1 Install Certbot
```bash
sudo apt install certbot python3-certbot-nginx -y
```

### 7.2 Generate Certificate
```bash
sudo certbot certonly --nginx -d your-domain.com -d www.your-domain.com
```

### 7.3 Update Nginx Configuration
Uncomment and configure the HTTPS section in `nginx.conf`:
```bash
sudo nano /etc/nginx/sites-available/default
```

### 7.4 Restart Nginx
```bash
sudo systemctl restart nginx
```

---

## Troubleshooting

### Container fails to start
```bash
# Check error logs
docker logs devops-app

# Rebuild image
docker build -t devops-app:latest .

# Run with interactive terminal for debugging
docker run -it -p 3000:3000 devops-app:latest
```

### Nginx returning 502 Bad Gateway
```bash
# Check if Node app is running
docker ps | grep devops-app

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log

# Verify proxy settings in Nginx config
sudo nginx -t
```

### GitHub Actions fails
1. Check the **Actions** tab for error messages
2. Verify SSH secrets are correct
3. Test SSH connection manually:
   ```bash
   ssh -i /path/to/private-key ubuntu@YOUR_SERVER_IP
   ```

### Port 3000 already in use
```bash
# Find and kill process using port 3000
sudo lsof -i :3000
sudo kill -9 <PID>

# Or use different port in docker run
docker run -d -p 3001:3000 devops-app:latest
```

---

## Useful Commands

```bash
# Docker commands
docker build -t devops-app:latest .      # Build image
docker run -d -p 3000:3000 devops-app   # Run container
docker ps                                # List running containers
docker logs devops-app                   # View logs
docker stop devops-app                   # Stop container
docker rm devops-app                     # Remove container
docker system prune                      # Clean up unused resources

# Nginx commands
sudo systemctl start nginx                # Start Nginx
sudo systemctl stop nginx                 # Stop Nginx
sudo systemctl restart nginx              # Restart Nginx
sudo systemctl enable nginx               # Enable on boot
sudo nginx -t                             # Test configuration
sudo tail -f /var/log/nginx/access.log   # View logs

# Git commands
git clone <repo-url>                      # Clone repository
git pull                                  # Pull latest changes
git push origin main                      # Push to main branch
git log                                   # View commit history
```

---

## Project Structure

```
.
├── server.js                    # Node.js Express app
├── package.json                 # Dependencies
├── Dockerfile                   # Docker configuration
├── .dockerignore               # Docker ignore rules
├── nginx.conf                   # Nginx reverse proxy config
├── .env.example                 # Environment variables template
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
└── README.md                    # Project documentation
```

---

## Next Steps

- [ ] Create GitHub repository
- [ ] Push code to GitHub
- [ ] Launch AWS EC2 or GCP VM
- [ ] Install Docker, Nginx, Git on server
- [ ] Configure Nginx
- [ ] Deploy manually first
- [ ] Add GitHub secrets
- [ ] Push code and trigger GitHub Actions
- [ ] Verify automatic deployment
- [ ] Setup SSL/HTTPS (optional)
- [ ] Monitor logs and performance

---

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS EC2 Guide](https://docs.aws.amazon.com/ec2/)
- [GCP Compute Engine Guide](https://cloud.google.com/compute/docs)
- [Let's Encrypt SSL](https://letsencrypt.org/)

---

## Support

For issues or questions, check the troubleshooting section or refer to official documentation of the respective tools.
