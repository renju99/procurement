# Using the Same Cloudflare Tunnel for Vendor Form

## Overview

You're now using the same Cloudflare tunnel (`35facd18-8eec-4678-aaf6-e8c5e11785e9`) that's already configured for guardpro. This eliminates the need for a separate tunnel and avoids certificate errors.

## What Changed

1. ✅ Removed separate `cloudflared` container from vendor-form
2. ✅ Exposed nginx on `localhost:9000` so guardpro cloudflared can access it
3. ⏳ Need to add route in Cloudflare dashboard

## Option 1: Add Route via Cloudflare Dashboard (Recommended)

### Steps:

1. **Go to Cloudflare Dashboard**
   - Login to [dash.cloudflare.com](https://dash.cloudflare.com)
   - Navigate to **Zero Trust** → **Networks** → **Tunnels**

2. **Find Your Tunnel**
   - Look for tunnel ID: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
   - Click on the tunnel name

3. **Add Public Hostname**
   - Click **"Public Hostname"** tab
   - Click **"Add a public hostname"**

4. **Configure the Route**
   - **Subdomain**: `vendor`
   - **Domain**: `berkeleyuae.com` (or `proptechme.com` if berkeleyuae.com is not on Cloudflare)
   - **Service**: `http://localhost:9000`
   - **Path**: Leave empty (routes all paths)
   - Click **Save**

5. **Verify DNS**
   - If using `vendor.berkeleyuae.com`, ensure the domain is on Cloudflare OR create CNAME at your registrar
   - If using `vendor.proptechme.com`, DNS is already managed by Cloudflare

## Option 2: Use Config File (Alternative)

If you prefer managing routes via config file, you can switch guardpro to use a config file instead of just a token.

### Steps:

1. **Download Tunnel Credentials**
   - In Cloudflare Dashboard → Zero Trust → Networks → Tunnels
   - Click on your tunnel
   - Go to **"Configure"** tab
   - Download the credentials file (JSON format)
   - Save it as `cloudflared-credentials.json` in the guardpro directory

2. **Create Config File**
   - Create `cloudflared-config.yml` in guardpro directory with:
   ```yaml
   tunnel: 35facd18-8eec-4678-aaf6-e8c5e11785e9
   credentials-file: /etc/cloudflared/credentials.json
   
   ingress:
     # Guardpro/Odoo route (update with your actual domain)
     - hostname: your-guardpro-domain.com
       service: http://localhost:8069
     
     # Vendor form route
     - hostname: vendor.berkeleyuae.com
       service: http://localhost:9000
     
     # Catch-all (must be last)
     - service: http_status:404
   ```

3. **Update guardpro docker-compose.yml**
   - Change cloudflared command from token to config:
   ```yaml
   cloudflared:
     image: cloudflare/cloudflared:latest
     command: tunnel --no-autoupdate --config /etc/cloudflared/config.yml run
     volumes:
       - ./cloudflared-config.yml:/etc/cloudflared/config.yml:ro
       - ./cloudflared-credentials.json:/etc/cloudflared/credentials.json:ro
     network_mode: host
     restart: unless-stopped
     container_name: cloudflared-tunnel
   ```

## Current Setup

### Vendor Form Services
- **Backend**: Running on `localhost:3001` (internal)
- **Nginx**: Running on `localhost:9000` (accessible to cloudflared)
- **No separate cloudflared**: Uses guardpro's tunnel

### Guardpro Services
- **Cloudflared**: Uses tunnel `35facd18-8eec-4678-aaf6-e8c5e11785e9`
- **Network mode**: `host` (can access localhost services)

## Testing

After adding the route:

1. **Start vendor-form services:**
   ```bash
   docker-compose -f docker-compose-cloudflare.yml up -d
   ```

2. **Verify nginx is accessible:**
   ```bash
   curl http://localhost:9000/api/health
   ```

3. **Test the domain:**
   ```bash
   curl https://vendor.berkeleyuae.com/api/health
   ```

## Troubleshooting

### Route not working?
- Check Cloudflare dashboard → Tunnels → Your tunnel → Public hostnames
- Verify the service URL is `http://localhost:9000`
- Check nginx logs: `docker logs vendor-form-nginx`

### Certificate errors?
- This should be resolved now since we're using the existing tunnel
- If you see errors, ensure you're using Option 1 (dashboard) or have correct credentials file for Option 2

### Nginx not accessible?
- Verify nginx is running: `docker ps | grep vendor-form-nginx`
- Check port binding: `netstat -an | findstr 9000` (Windows) or `ss -tlnp | grep 9000` (Linux)


