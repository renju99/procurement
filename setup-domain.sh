#!/bin/bash
# Quick setup script for deploying to supplier.proptechme.com

echo "=== Vendor Form Domain Setup ==="
echo ""

# Check if domain resolves
echo "Checking DNS for supplier.proptechme.com..."
if nslookup supplier.proptechme.com > /dev/null 2>&1; then
    echo "✓ DNS is configured"
    nslookup supplier.proptechme.com | grep -A 1 "Name:"
else
    echo "✗ DNS not configured yet. Please set up A record pointing to this server."
    exit 1
fi

echo ""
echo "Starting services with Nginx reverse proxy..."
docker-compose -f docker-compose-nginx.yml up -d

echo ""
echo "Waiting for services to start..."
sleep 5

echo ""
echo "Checking service status..."
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "Testing backend health..."
curl -s http://localhost:3001/api/health | jq . || echo "Backend health check failed"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Verify form is accessible: http://supplier.proptechme.com"
echo "2. Set up SSL certificate:"
echo "   sudo certbot --nginx -d supplier.proptechme.com"
echo "3. Test form submission"
echo ""
echo "View logs:"
echo "  docker logs -f vendor-form-backend"
echo "  docker logs -f vendor-form-nginx"

