# Quick Start Guide

Get your DevOps project running in 3 ways: **Local Dev**, **Docker Local**, or **Cloud Deployment**.

---

## 🖥️ Option 1: Local Development (5 minutes)

### Prerequisites
- Node.js 18+ installed
- npm installed

### Steps

```bash
# 1. Clone repository
git clone <repository-url>
cd DevOps-Deployment-Project

# 2. Install dependencies
npm install

# 3. Start server
npm start

# 4. Test in another terminal
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/info
```

**Access app:** http://localhost:3000

---

## 🐳 Option 2: Docker Local (10 minutes)

### Prerequisites
- Docker installed
- Docker Compose (optional)

### Using Docker Commands

```bash
# 1. Clone repository
git clone <repository-url>
cd DevOps-Deployment-Project

# 2. Build image
docker build -t devops-app .

# 3. Run container
docker run -d \
  --name devops-app \
  -p 3000:3000 \
  devops-app

# 4. Test
curl http://localhost:3000

# 5. View logs
docker logs devops-app

# 6. Stop container
docker stop devops-app
docker rm devops-app
```

### Using Docker Compose (Easier)

```bash
# 1. Clone repository
git clone <repository-url>
cd DevOps-Deployment-Project

# 2. Start everything
docker-compose up -d

# 3. Test
curl http://localhost      # Via Nginx (port 80)
curl http://localhost:3000  # Direct to app

# 4. View logs
docker-compose logs -f app

# 5. Stop everything
docker-compose down
```

**Access app:** http://localhost (with Nginx) or http://localhost:3000 (direct)

---

## ☁️ Option 3: Cloud Deployment (30 minutes)

Complete guide in [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

### Quick Summary

1. **Launch VM** (AWS EC2 or GCP Compute Engine)
   - Choose Ubuntu 20.04 LTS
   - t3.micro / e2-micro (free tier eligible)
   - Note: Public IP address

2. **SSH into server**
   ```bash
   ssh -i your-key.pem ubuntu@YOUR_PUBLIC_IP
   ```

3. **Run setup script**
   ```bash
   curl https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/server-setup.sh | bash
   # Or manually: chmod +x server-setup.sh && ./server-setup.sh
   ```

4. **Deploy app**
   ```bash
   cd ~/devops-app
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git .
   docker build -t devops-app .
   docker run -d -p 3000:3000 --name devops-app devops-app
   ```

5. **Configure Nginx**
   ```bash
   sudo nano /etc/nginx/sites-available/default
   # Copy content from nginx.conf
   sudo systemctl restart nginx
   ```

6. **Access app**
   - http://YOUR_PUBLIC_IP

7. **Setup GitHub Actions**
   - Add secrets: `SERVER_IP`, `SERVER_USER`, `SSH_KEY`
   - Workflow in `.github/workflows/deploy.yml` runs automatically on push

---

## 📊 Useful Commands Reference

### Node.js / npm
```bash
npm install          # Install dependencies
npm start           # Start server
npm run dev         # Run in development mode
```

### Docker
```bash
docker build -t devops-app .                        # Build image
docker run -d -p 3000:3000 devops-app             # Run container
docker ps                                           # List containers
docker logs devops-app                             # View logs
docker logs -f devops-app                          # Follow logs
docker stop devops-app                             # Stop container
docker rm devops-app                               # Remove container
docker system prune                                # Clean up
```

### Docker Compose
```bash
docker-compose up                    # Start services
docker-compose up -d                 # Start in background
docker-compose down                  # Stop services
docker-compose logs -f               # View logs
docker-compose ps                    # List services
```

### Linux / Server
```bash
sudo systemctl start nginx           # Start Nginx
sudo systemctl restart nginx         # Restart Nginx
sudo systemctl stop nginx            # Stop Nginx
sudo systemctl enable nginx          # Enable on boot
sudo nginx -t                        # Test Nginx config
sudo tail -f /var/log/nginx/access.log  # View access logs
sudo tail -f /var/log/nginx/error.log   # View error logs
```

### Testing
```bash
curl http://localhost:3000                    # Test root
curl http://localhost:3000/health            # Test health
curl http://localhost:3000/api/info          # Test API
curl -v http://localhost:3000                # Verbose output
```

---

## 🔍 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/` | GET | App status |
| `/health` | GET | Health check |
| `/api/info` | GET | Architecture info |

---

## 🚨 Common Issues

### Docker container won't start
```bash
docker logs devops-app
# Check error and rebuild
docker build -t devops-app .
```

### Port already in use
```bash
# Find process on port 3000
lsof -i :3000
# Kill it
kill -9 <PID>
```

### Nginx 502 Bad Gateway
```bash
# Make sure app is running
docker ps | grep devops-app
# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### GitHub Actions fails to deploy
1. Verify secrets are set correctly in GitHub Settings
2. Test SSH connection manually:
   ```bash
   ssh -i your-key ubuntu@YOUR_SERVER_IP
   ```
3. Check GitHub Actions logs for detailed error

---

## 📚 Full Documentation

- **[README.md](README.md)** - Project overview
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Complete deployment walkthrough
- **[Dockerfile](Dockerfile)** - Container configuration
- **[nginx.conf](nginx.conf)** - Reverse proxy config
- **.github/workflows/deploy.yml** - CI/CD pipeline

---

## 🎯 Next Steps

1. ✅ Choose deployment method (Local / Docker / Cloud)
2. ✅ Follow steps above
3. ✅ Test endpoints with `curl`
4. ✅ For cloud: Add GitHub secrets and test auto-deployment
5. ✅ Read [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for deeper understanding

---

## 💡 Pro Tips

- **Local testing** - Use `npm start` for fastest development
- **Docker testing** - Use `docker-compose` for full stack locally
- **Cloud deployment** - Test manually first, then setup CI/CD
- **Debugging** - Always check logs: `docker logs -f devops-app`
- **Monitoring** - Use `/health` endpoint for uptime monitoring

---

**Need help? Check [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md#troubleshooting) troubleshooting section!**
