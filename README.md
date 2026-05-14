# DevOps Deployment Project

A complete Node.js web application with production-ready DevOps setup including Docker containerization, Nginx reverse proxy, and GitHub Actions CI/CD pipeline.

## 🎯 Project Overview

This project demonstrates a professional DevOps workflow:

```
GitHub Repository → GitHub Actions CI/CD → AWS EC2/GCP VM → Docker Container → Nginx Reverse Proxy → Public Website
```

### Key Features

- ✅ **Node.js + Express** - Simple, scalable backend
- 🐳 **Docker** - Containerized application
- 🔄 **GitHub Actions** - Automated CI/CD pipeline
- 🌐 **Nginx** - Reverse proxy for production
- ☁️ **Cloud Ready** - Deploy to AWS EC2 or GCP Compute Engine
- 📊 **Health Checks** - Built-in monitoring endpoints
- 🔐 **Security** - Proper proxy headers and configurations

---

## 📁 Project Structure

```
.
├── server.js                      # Express.js application
├── package.json                   # Node.js dependencies
├── Dockerfile                     # Docker image configuration
├── .dockerignore                  # Docker ignore rules
├── nginx.conf                     # Nginx reverse proxy config
├── .env.example                   # Environment variables template
├── .github/
│   └── workflows/
│       └── deploy.yml            # GitHub Actions CI/CD workflow
├── DEPLOYMENT_GUIDE.md           # Complete deployment instructions
└── README.md                      # This file
```

---

## 🚀 Quick Start

### 1. Local Development

```bash
# Install dependencies
npm install

# Run server
npm start

# Test endpoints
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/info
```

### 2. Docker Locally

```bash
# Build image
docker build -t devops-app .

# Run container
docker run -p 3000:3000 devops-app

# Access app
curl http://localhost:3000
```

### 3. Deploy to Cloud

Follow the detailed **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** for:
- Setting up Linux VM (AWS EC2 or GCP)
- Installing Docker & Nginx
- Configuring Nginx reverse proxy
- Setting up GitHub Actions secrets
- Automated deployment on code push

---

## 📋 API Endpoints

### GET `/`
Returns app status and basic info.

**Response:**
```json
{
  "message": "DevOps Project Running",
  "status": "success",
  "timestamp": "2024-05-14T10:30:00.000Z",
  "version": "1.0.0"
}
```

### GET `/health`
Health check endpoint for monitoring.

**Response:**
```json
{
  "status": "healthy",
  "uptime": 1234.56,
  "environment": "production"
}
```

### GET `/api/info`
Application architecture details.

**Response:**
```json
{
  "app": "DevOps Deployment Project",
  "description": "Node.js app deployed with Docker, Nginx, and GitHub Actions",
  "architecture": {
    "frontend": "Public Website",
    "backend": "Node.js + Express",
    "proxy": "Nginx Reverse Proxy",
    "container": "Docker",
    "ci_cd": "GitHub Actions",
    "deployment": "AWS EC2 / GCP Compute Engine"
  }
}
```

---

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and update as needed:

```bash
cp .env.example .env
```

Available variables:
- `NODE_ENV` - Set to `production` for production deployments
- `PORT` - Server port (default: 3000)

### Nginx Configuration

Edit `nginx.conf` to:
- Change server name to your domain
- Add SSL/HTTPS certificates
- Adjust proxy settings

---

## 🔐 GitHub Actions Secrets

For automatic deployment, add these secrets in GitHub repository settings:

| Secret | Value |
|--------|-------|
| `SERVER_IP` | Your server's public IP address |
| `SERVER_USER` | SSH username (usually `ubuntu`) |
| `SSH_KEY` | Private SSH key contents |

**Setup Instructions:**
1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add each secret above

---

## 📊 Monitoring

### View Application Logs
```bash
docker logs devops-app
docker logs -f devops-app  # Follow in real-time
```

### View Nginx Logs
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Check Container Status
```bash
docker ps
docker stats devops-app
```

---

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| Container won't start | Check Docker logs: `docker logs devops-app` |
| Nginx 502 error | Verify Node app is running: `docker ps` |
| GitHub Actions fails | Check SSH secrets are correct in repository settings |
| Port 3000 in use | Kill process: `sudo lsof -i :3000 && sudo kill -9 <PID>` |

For detailed troubleshooting, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md#troubleshooting).

---

## 🔄 Deployment Workflow

### Automatic Deployment (GitHub Actions)

1. Make changes to code
2. Commit and push to `main` branch:
   ```bash
   git add .
   git commit -m "Update app"
   git push origin main
   ```
3. GitHub Actions automatically:
   - Connects to your server via SSH
   - Pulls latest code
   - Rebuilds Docker image
   - Stops old container
   - Starts new container
   - Verifies deployment

### Manual Deployment

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/devops-app
git pull
docker build -t devops-app .
docker stop devops-app || true
docker rm devops-app || true
docker run -d -p 3000:3000 --name devops-app devops-app
```

---

## 🛠️ Tech Stack

- **Runtime**: Node.js 18
- **Framework**: Express.js
- **Containerization**: Docker (Alpine Linux)
- **Web Server**: Nginx
- **CI/CD**: GitHub Actions
- **Cloud**: AWS EC2 / GCP Compute Engine
- **OS**: Ubuntu 20.04 LTS

---

## 📖 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Express.js Guide](https://expressjs.com/)
- [Nginx Documentation](https://nginx.org/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [AWS EC2](https://docs.aws.amazon.com/ec2/)
- [GCP Compute Engine](https://cloud.google.com/compute/docs)

---

## 📝 What You Learn

This project covers essential DevOps skills:

✅ **Backend Development** - Node.js + Express  
✅ **Docker** - Containerization and image building  
✅ **Linux** - VM management and command-line operations  
✅ **Nginx** - Reverse proxy and web server configuration  
✅ **CI/CD** - GitHub Actions automated deployment  
✅ **Cloud Infrastructure** - AWS EC2 or GCP VM deployment  
✅ **Networking** - Port forwarding and proxy configuration  
✅ **Security** - SSH keys, environment variables, secrets management  

---

## 🎓 Next Steps

1. **Clone/Fork this repository**
2. **Read [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** for complete deployment steps
3. **Launch a cloud VM** (AWS EC2 or GCP)
4. **Follow deployment steps** to get your app running
5. **Configure GitHub secrets** for CI/CD
6. **Test automatic deployment** by pushing code

---

## 📄 License

MIT License - Feel free to use this project for learning and development.

---

## 💡 Tips for Success

- Start by deploying manually first to understand each step
- Monitor logs: `docker logs -f devops-app`
- Test Nginx: `sudo nginx -t`
- Use `curl` to test endpoints
- Check GitHub Actions logs if automated deployment fails
- Keep SSH key secure - never commit to repo
- Use environment variables for sensitive config

---

## Support & Questions

- Check [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md#troubleshooting) for troubleshooting
- Review GitHub Actions logs for deployment issues
- Verify all secrets are correctly set in GitHub
- Test SSH connection manually before CI/CD

---

**Ready to deploy? Start with [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)!**