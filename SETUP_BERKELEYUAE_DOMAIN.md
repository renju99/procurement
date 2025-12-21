# Setting Up Domain: vendor.berkeleyuae.com

This guide will help you configure the vendor registration form to use `vendor.berkeleyuae.com` instead of the proptechme.com domain.

## ✅ Configuration Updated

The Nginx configuration files have been updated to use `vendor.berkeleyuae.com`:
- ✅ `nginx-docker.conf` - Updated for Docker deployment
- ✅ `nginx.conf` - Updated for manual Nginx installation
- ✅ `vendor-registration-form.html` - Automatically works with any domain

## Step 1: Configure DNS

In your domain provider's DNS settings for `berkeleyuae.com`, add an **A Record**:

```
Type: A
Name: vendor
Value: [Your Server's Public IP Address]
TTL: 3600
```

**Example DNS Configuration:**
```
Name: vendor
Type: A
Value: 123.45.67.89  (Your actual server IP)
TTL: 3600
```

### Verify DNS

Wait 5-30 minutes for DNS propagation, then verify:

```bash
nslookup vendor.berkeleyuae.com
# or
dig vendor.berkeleyuae.com
```

You should see your server's IP address in the response.

## Step 2: Deploy with Docker (Recommended)

```bash
# Start the services
docker-compose -f docker-compose-nginx.yml up -d

# Check status
docker ps
docker logs vendor-form-nginx
docker logs vendor-form-backend
```

## Step 3: Test HTTP Access

```bash
# Test the domain
curl -I http://vendor.berkeleyuae.com

# Test the API
curl http://vendor.berkeleyuae.com/api/health
```

Open in browser: **http://vendor.berkeleyuae.com**

## Step 4: Set Up SSL (HTTPS) - Highly Recommended

### Using Let's Encrypt (Free SSL)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d vendor.berkeleyuae.com

# Certbot will automatically:
# 1. Obtain the certificate
# 2. Update your nginx.conf with SSL configuration
# 3. Set up automatic renewal
```

### For Docker Deployment with SSL

1. **Get certificate on host machine:**
   ```bash
   sudo certbot certonly --standalone -d vendor.berkeleyuae.com
   ```

2. **Update docker-compose-nginx.yml** to mount SSL certificates:
   ```yaml
   nginx:
     volumes:
       - ./nginx-docker.conf:/etc/nginx/conf.d/default.conf:ro
       - /etc/letsencrypt:/etc/letsencrypt:ro  # Uncomment this line
   ```

3. **Update nginx-docker.conf** - Uncomment and update the SSL section:
   ```nginx
   server {
       listen 443 ssl http2;
       server_name vendor.berkeleyuae.com;
   
       ssl_certificate /etc/letsencrypt/live/vendor.berkeleyuae.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/vendor.berkeleyuae.com/privkey.pem;
       # ... rest of SSL config
   }
   ```

4. **Restart Docker:**
   ```bash
   docker-compose -f docker-compose-nginx.yml restart
   ```

## Step 5: Verify Everything Works

1. **Test HTTP:**
   ```bash
   curl -I http://vendor.berkeleyuae.com
   ```

2. **Test HTTPS (after SSL setup):**
   ```bash
   curl -I https://vendor.berkeleyuae.com
   ```

3. **Test API:**
   ```bash
   curl https://vendor.berkeleyuae.com/api/health
   ```

4. **Open in browser:**
   - `http://vendor.berkeleyuae.com` (or `https://` after SSL setup)
   - Submit a test form to verify everything works

## Firewall Configuration

Make sure ports 80 and 443 are open:

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

## Troubleshooting

### Domain not resolving?
```bash
# Check DNS
nslookup vendor.berkeleyuae.com
dig vendor.berkeleyuae.com

# Wait for DNS propagation (5-30 minutes, up to 48 hours)
```

### Nginx not starting?
```bash
# Check Docker logs
docker logs vendor-form-nginx

# Test Nginx config (if manual install)
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

### Backend not responding?
```bash
# Check backend logs
docker logs vendor-form-backend

# Test backend directly
curl http://localhost:3001/api/health
```

### SSL certificate issues?
```bash
# Check certificate
sudo certbot certificates

# Renew manually if needed
sudo certbot renew --force-renewal
```

## Quick Commands Reference

```bash
# Start services
docker-compose -f docker-compose-nginx.yml up -d

# Stop services
docker-compose -f docker-compose-nginx.yml down

# View logs
docker-compose -f docker-compose-nginx.yml logs -f

# Restart services
docker-compose -f docker-compose-nginx.yml restart

# Check status
docker ps
```

## What Changed?

✅ **Nginx Configuration:**
- `server_name` changed from `supplier.proptechme.com` to `vendor.berkeleyuae.com`
- SSL certificate paths updated to use `vendor.berkeleyuae.com`

✅ **HTML Form:**
- No changes needed - automatically detects any production domain
- Works seamlessly with `vendor.berkeleyuae.com`

✅ **Backend Server:**
- No changes needed - works with any domain

## Next Steps

1. ✅ DNS configured → `vendor.berkeleyuae.com` points to your server
2. ✅ Services running → Docker containers are up
3. ✅ HTTP working → Can access `http://vendor.berkeleyuae.com`
4. ⏳ SSL setup → Get HTTPS certificate (recommended)
5. ⏳ Test form → Submit a test registration

## Security Notes

- ✅ Always use HTTPS in production
- ✅ Keep Docker images updated
- ✅ Regularly backup form submissions and uploaded files
- ✅ Monitor logs for suspicious activity

---

**Your form is now configured for `vendor.berkeleyuae.com`!** 🎉

The proptechme.com domain is now hidden - users will only see `vendor.berkeleyuae.com` when accessing the form.



