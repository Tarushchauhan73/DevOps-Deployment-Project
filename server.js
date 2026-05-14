const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.get("/", (req, res) => {
  res.json({
    message: "DevOps Project Running",
    status: "success",
    timestamp: new Date().toISOString(),
    version: "1.0.0"
  });
});

app.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development"
  });
});

app.get("/api/info", (req, res) => {
  res.json({
    app: "DevOps Deployment Project",
    description: "Node.js app deployed with Docker, Nginx, and GitHub Actions",
    architecture: {
      frontend: "Public Website",
      backend: "Node.js + Express",
      proxy: "Nginx Reverse Proxy",
      container: "Docker",
      ci_cd: "GitHub Actions",
      deployment: "AWS EC2 / GCP Compute Engine"
    }
  });
});

// Error handling
app.use((req, res) => {
  res.status(404).json({
    error: "Not Found",
    message: "The requested resource does not exist"
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
});
