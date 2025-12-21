# Setting Up a Custom Domain (Hide proptechme.com)

This guide explains how to use a custom domain instead of `vendor.proptechme.com` or `supplier.proptechme.com`.

## Overview

You can use **any domain you own** to host the vendor registration form. For example:
- `vendor.berkeley.com`
- `supplier.berkeley.com`
- `vendor.yourcompany.com`
- Any other domain you control

## Step 1: Choose Your Domain

Decide which domain you want to use. Make sure you have:
- Ownership/access to the domain
- Ability to modify DNS records

## Step 2: Update Nginx Configuration

### For Docker Deployment (docker-compose-nginx.yml)

Edit `nginx-docker.conf` and update the `server_name`:

```nginx
server {
    listen 80;
    server_name vendor.berkeley.com;  # Replace with your custom domain
    # ... rest of config
}
```

### For Manual Nginx Installation

Edit `nginx.conf` and update the `server_name`:

```nginx
server {
    listen 80;
    server_name vendor.berkeley.com;  # Replace with your custom domain
    # ... rest of config
}
```

**Note:** You can also support multiple domains by listing them:
```nginx
server_name vendor.berkeley.com supplier.proptechme.com;
```

## Step 3: Configure DNS

In your domain provider's DNS settings, add an **A Record**:

```
Type: A
Name: vendor (or @ for root domain)
Value: [Your Server's Public IP Address]
TTL: 3600
```

**Examples:**
- For `vendor.berkeley.com`: Name = `vendor`
- For `supplier.berkeley.com`: Name = `supplier`
- For `berkeley.com`: Name = `@` or leave blank

### Verify DNS

Wait 5-30 minutes for DNS propagation, then verify:

```bash
nslookup vendor.berkeley.com
# or
dig vendor.berkeley.com
```

## Step 4: Update Docker Compose (if using Docker)

No changes needed - the form automatically detects any production domain!

## Step 5: Restart Services

### Docker:
```bash
docker-compose -f docker-compose-nginx.yml down
docker-compose -f docker-compose-nginx.yml up -d
```

### Manual Nginx:
```bash
sudo nginx -t  # Test configuration
sudo systemctl reload nginx
```

## Step 6: Set Up SSL (HTTPS) - Recommended

### Using Let's Encrypt (Free SSL)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate for your custom domain
sudo certbot --nginx -d vendor.berkeley.com

# Certbot will automatically update your nginx.conf
```

### For Docker with SSL

1. Get the certificate on the host:
```bash
sudo certbot certonly --standalone -d vendor.berkeley.com
```

2. Update `docker-compose-nginx.yml` to mount SSL certificates:
```yaml
nginx:
  volumes:
    - ./nginx-docker.conf:/etc/nginx/conf.d/default.conf:ro
    - /etc/letsencrypt:/etc/letsencrypt:ro  # Uncomment this
```

3. Update `nginx-docker.conf` with SSL configuration (uncomment SSL section)

## Step 7: Test Your Custom Domain

1. **Test HTTP:**
   ```bash
   curl -I http://vendor.berkeley.com
   ```

2. **Test HTTPS (after SSL):**
   ```bash
   curl -I https://vendor.berkeley.com
   ```

3. **Test API:**
   ```bash
   curl http://vendor.berkeley.com/api/health
   ```

4. **Open in browser:**
   - `http://vendor.berkeley.com` (or `https://` after SSL setup)

## How It Works

The form automatically detects the domain:
- ✅ **Any production domain** (not localhost) → Uses same-origin API (`/api/submit`)
- ✅ **localhost** → Uses `http://localhost:3001/api/submit`

No changes needed to the HTML file - it works with any domain automatically!

## Supporting Multiple Domains

You can support both your custom domain AND the old proptechme domain:

```nginx
server {
    listen 80;
    server_name vendor.berkeley.com vendor.proptechme.com supplier.proptechme.com;
    # ... rest of config
}
```

This allows users to access the form from any of these domains.

## Troubleshooting

### Domain not resolving?
- Check DNS: `nslookup vendor.berkeley.com`
- Wait for DNS propagation (can take up to 48 hours, usually 5-30 minutes)
- Verify A record is correct in your DNS provider

### Nginx not responding?
```bash
# Check Nginx logs
docker logs vendor-form-nginx
# or
sudo tail -f /var/log/nginx/error.log

# Test Nginx config
sudo nginx -t
```

### SSL certificate issues?
```bash
# Check certificate
sudo certbot certificates

# Renew manually if needed
sudo certbot renew --force-renewal
```

### Form not submitting?
- Check browser console for errors
- Verify API endpoint: `curl http://vendor.berkeley.com/api/health`
- Check backend logs: `docker logs vendor-form-backend`

## Security Notes

1. **Always use HTTPS in production** - Set up SSL certificates
2. **Update CORS if needed** - The server currently allows all origins, but you can restrict it in `server.js`
3. **Firewall** - Only open ports 80 and 443

## Quick Reference

**Files to update:**
- `nginx-docker.conf` (for Docker) or `nginx.conf` (for manual install)
- DNS settings in your domain provider

**Files that auto-detect domain (no changes needed):**
- `vendor-registration-form.html` - Automatically works with any domain
- `server.js` - No domain-specific configuration needed

## Example: Switching from proptechme.com to berkeley.com

1. Update `nginx-docker.conf`: Change `server_name vendor.proptechme.com;` to `server_name vendor.berkeley.com;`
2. Add DNS A record: `vendor.berkeley.com` → Your Server IP
3. Restart: `docker-compose -f docker-compose-nginx.yml restart`
4. Set up SSL: `sudo certbot --nginx -d vendor.berkeley.com`
5. Done! Users can now access via `vendor.berkeley.com` (proptechme.com is hidden)

---

**Need help?** Check the main deployment guides:
- `DEPLOYMENT_DOMAIN.md` - Detailed deployment guide
- `START_WITH_DOMAIN.md` - Quick start guide



