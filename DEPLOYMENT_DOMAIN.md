# Deploying to Domain: supplier.proptechme.com

## Overview
This guide will help you expose your vendor registration form on `supplier.proptechme.com` using Nginx as a reverse proxy.

## Prerequisites
- Server with public IP address
- Domain `supplier.proptechme.com` configured to point to your server IP
- Docker and Docker Compose installed
- Ports 80 and 443 open in firewall

## Step 1: DNS Configuration

1. **Set DNS A Record:**
   ```
   Type: A
   Name: supplier (or @ for root domain)
   Value: [Your Server IP Address]
   TTL: 3600
   ```

2. **Verify DNS:**
   ```bash
   nslookup supplier.proptechme.com
   # or
   dig supplier.proptechme.com
   ```

## Step 2: Update Docker Compose

The backend should only listen on localhost (127.0.0.1) since Nginx will be the public-facing service:

```yaml
ports:
  - "127.0.0.1:3001:3000"  # Only accessible from localhost
```

## Step 3: Deploy with Nginx

### Option A: Using Docker Compose (Recommended)

1. **Use the new docker-compose file:**
   ```bash
   docker-compose -f docker-compose-nginx.yml up -d
   ```

2. **Check status:**
   ```bash
   docker ps
   docker logs vendor-form-nginx
   docker logs vendor-form-backend
   ```

### Option B: Manual Nginx Installation

1. **Install Nginx:**
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install nginx -y
   
   # CentOS/RHEL
   sudo yum install nginx -y
   ```

2. **Copy Nginx config:**
   ```bash
   sudo cp nginx.conf /etc/nginx/sites-available/supplier.proptechme.com
   sudo ln -s /etc/nginx/sites-available/supplier.proptechme.com /etc/nginx/sites-enabled/
   ```

3. **Test and reload Nginx:**
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

## Step 4: Set Up SSL (HTTPS) - Recommended

### Using Let's Encrypt (Free SSL)

1. **Install Certbot:**
   ```bash
   # Ubuntu/Debian
   sudo apt install certbot python3-certbot-nginx -y
   
   # CentOS/RHEL
   sudo yum install certbot python3-certbot-nginx -y
   ```

2. **Obtain SSL Certificate:**
   ```bash
   sudo certbot --nginx -d supplier.proptechme.com
   ```

3. **Update Nginx Config:**
   - Certbot will automatically update your nginx.conf
   - Or uncomment the SSL section in nginx.conf and update paths

4. **Auto-renewal (already configured by certbot):**
   ```bash
   sudo certbot renew --dry-run
   ```

## Step 5: Firewall Configuration

```bash
# Ubuntu/Debian (UFW)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Step 6: Update Form for Production

The form automatically detects the domain and uses the correct API endpoint. However, verify:

1. **Open the form:** `http://supplier.proptechme.com` (or https://)
2. **Test submission** - should work without CORS errors

## Step 7: Verify Everything Works

1. **Test HTTP:**
   ```bash
   curl -I http://supplier.proptechme.com
   ```

2. **Test HTTPS (after SSL setup):**
   ```bash
   curl -I https://supplier.proptechme.com
   ```

3. **Test API:**
   ```bash
   curl http://supplier.proptechme.com/api/health
   ```

## Troubleshooting

### Nginx not starting
```bash
docker logs vendor-form-nginx
# or
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

### Backend not accessible
```bash
# Check backend is running on localhost:3001
curl http://localhost:3001/api/health

# Check Docker container
docker ps
docker logs vendor-form-backend
```

### DNS not resolving
```bash
# Check DNS propagation
nslookup supplier.proptechme.com
dig supplier.proptechme.com

# Wait 5-30 minutes for DNS propagation
```

### SSL Certificate Issues
```bash
# Check certificate
sudo certbot certificates

# Renew manually if needed
sudo certbot renew --force-renewal
```

## Security Considerations

1. **Firewall:** Only open ports 80 and 443
2. **Backend:** Only accessible from localhost (127.0.0.1)
3. **SSL:** Always use HTTPS in production
4. **Updates:** Keep Docker images and Nginx updated

## Monitoring

```bash
# Check Nginx access logs
docker exec vendor-form-nginx tail -f /var/log/nginx/access.log

# Check backend logs
docker logs -f vendor-form-backend

# Monitor container resources
docker stats vendor-form-backend vendor-form-nginx
```

## Quick Start Commands

```bash
# Start everything
docker-compose -f docker-compose-nginx.yml up -d

# Stop everything
docker-compose -f docker-compose-nginx.yml down

# View logs
docker-compose -f docker-compose-nginx.yml logs -f

# Restart
docker-compose -f docker-compose-nginx.yml restart
```

## Support

If you encounter issues:
1. Check Docker logs: `docker logs vendor-form-backend` and `docker logs vendor-form-nginx`
2. Verify DNS: `nslookup supplier.proptechme.com`
3. Test backend directly: `curl http://localhost:3001/api/health`
4. Check firewall: `sudo ufw status` or `sudo firewall-cmd --list-all`
