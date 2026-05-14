#!/bin/bash

# DevOps Server Setup Script
# Run this on your Ubuntu server to install required packages
# Usage: curl https://raw.githubusercontent.com/your-repo/main/server-setup.sh | bash
# OR: chmod +x server-setup.sh && ./server-setup.sh

set -e

echo "🚀 DevOps Server Setup"
echo "===================="
echo ""
echo "This script will install:"
echo "  - Docker"
echo "  - Nginx"
echo "  - Git"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install docker.io -y

# Add user to docker group
echo "👤 Adding $USER to docker group..."
sudo usermod -aG docker $USER

# Install Nginx
echo "🌐 Installing Nginx..."
sudo apt install nginx -y

# Install Git
echo "📚 Installing Git..."
sudo apt install git -y

# Enable Nginx on startup
echo "⚙️  Enabling Nginx on startup..."
sudo systemctl enable nginx

# Start Nginx
echo "🔄 Starting Nginx..."
sudo systemctl start nginx

echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Configure Nginx with: sudo nano /etc/nginx/sites-available/default"
echo "2. Clone the repository: git clone <repo-url> ~/devops-app"
echo "3. Build Docker image: cd ~/devops-app && docker build -t devops-app ."
echo "4. Run container: docker run -d -p 3000:3000 --name devops-app devops-app"
echo "5. Restart Nginx: sudo systemctl restart nginx"
echo ""
echo "🧪 Test the app:"
echo "   curl http://localhost:3000"
echo "   curl http://<public-ip>"
echo ""
echo "⚠️  NOTE: You may need to logout and login again for docker group changes to take effect"
echo ""
