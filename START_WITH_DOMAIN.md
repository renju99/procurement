# 🚀 Access Form via Domain: supplier.proptechme.com

## Quick Start (3 Steps)

### Step 1: DNS Configuration
In your domain provider, add an **A Record**:
```
Type: A
Name: supplier (or @ for root)
Value: [Your Server's Public IP Address]
TTL: 3600
```

Wait 5-10 minutes for DNS to propagate.

### Step 2: Start Services
```bash
cd standalone-form
docker-compose -f docker-compose-nginx.yml up -d
```

### Step 3: Access Your Form
Open in browser: **http://supplier.proptechme.com**

## What Happens

1. **Nginx** listens on ports 80 (HTTP) and 443 (HTTPS)
2. **Backend** runs on localhost:3001 (not exposed publicly)
3. **Nginx** proxies requests to the backend
4. **Domain** points to your server via DNS

## Files Created

- `docker-compose-nginx.yml` - Docker setup with Nginx
- `nginx.conf` - Nginx reverse proxy configuration
- Form already configured to work with the domain

## Set Up SSL (HTTPS) - Recommended

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d supplier.proptechme.com

# Access: https://supplier.proptechme.com
```

## Verify Everything Works

```bash
# Check DNS
nslookup supplier.proptechme.com

# Check services
docker ps

# Test form
curl http://supplier.proptechme.com
curl http://supplier.proptechme.com/api/health
```

## Troubleshooting

**Can't access domain?**
- Check DNS: `nslookup supplier.proptechme.com`
- Check firewall: `sudo ufw status`
- Check logs: `docker logs vendor-form-nginx`

**Backend not responding?**
- Check backend: `docker logs vendor-form-backend`
- Test directly: `curl http://localhost:3001/api/health`

**Need help?** See `DEPLOYMENT_DOMAIN.md` for detailed guide.

