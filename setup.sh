#!/bin/bash

# DevOps App - Local Development Setup Script
# This script helps set up the development environment locally

set -e

echo "🚀 DevOps Deployment Project - Local Setup"
echo "==========================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install it first."
    exit 1
fi

echo "✅ Node.js version: $(node -v)"
echo "✅ npm version: $(npm -v)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Copy .env.example to .env"
echo "2. Run 'npm start' to start the development server"
echo "3. Or run 'docker-compose up' to run with Docker"
echo ""
echo "🧪 Test the app:"
echo "   curl http://localhost:3000"
echo "   curl http://localhost:3000/health"
echo "   curl http://localhost:3000/api/info"
echo ""
