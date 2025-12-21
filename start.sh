#!/bin/bash

# Quick start script for Docker deployment

echo "🚀 Starting Vendor Registration Form Backend..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  Docker Compose not found. Using docker run instead..."
    docker build -t vendor-form-backend .
    docker run -d \
        --name vendor-form-backend \
        -p 3000:3000 \
        -v $(pwd)/uploads:/app/uploads \
        -v $(pwd)/data:/app/data \
        vendor-form-backend
    echo "✅ Backend started on http://localhost:3000"
    echo "📋 Check logs: docker logs vendor-form-backend"
    exit 0
fi

# Use Docker Compose
echo "📦 Building and starting containers..."
docker-compose up -d

echo "✅ Backend is starting..."
echo "📋 View logs: docker-compose logs -f"
echo "🌐 Health check: http://localhost:3000/api/health"
echo "📝 API endpoint: http://localhost:3000/api/submit"

