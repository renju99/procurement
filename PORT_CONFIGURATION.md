# Port Configuration for vendor.berkeleyuae.com

## Current Setup

Since ports **80** and **443** are already in use by other applications (3CX), the vendor registration form is configured to use:

- **HTTP**: Port **8080**
- **HTTPS**: Port **8443**

## Accessing the Form

### Option 1: Access via Port Number (Recommended)

Users will access the form using:
- **HTTP**: `http://vendor.berkeleyuae.com:8080`
- **HTTPS**: `https://vendor.berkeleyuae.com:8443` (after SSL setup)

### Option 2: Use a Reverse Proxy (Advanced)

If you want to hide the port number, you can set up a reverse proxy (like Cloudflare, or another nginx instance) that:
1. Listens on ports 80/443
2. Forwards requests to `vendor.berkeleyuae.com:8080`

## Current Configuration

- **Backend**: Running on `localhost:3001` (internal only)
- **Nginx**: Running on ports `8080` (HTTP) and `8443` (HTTPS)
- **Domain**: `vendor.berkeleyuae.com`

## Testing

### Test HTTP:
```powershell
Invoke-WebRequest -Uri http://vendor.berkeleyuae.com:8080
Invoke-WebRequest -Uri http://vendor.berkeleyuae.com:8080/api/health
```

### Test in Browser:
Open: **http://vendor.berkeleyuae.com:8080**

## SSL Setup (Optional)

If you want HTTPS on port 8443:

1. **Get SSL certificate:**
   ```bash
   sudo certbot certonly --standalone -d vendor.berkeleyuae.com
   ```

2. **Update nginx-docker.conf** - Add SSL server block:
   ```nginx
   server {
       listen 443 ssl http2;
       server_name vendor.berkeleyuae.com;
       
       ssl_certificate /etc/letsencrypt/live/vendor.berkeleyuae.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/vendor.berkeleyuae.com/privkey.pem;
       # ... rest of SSL config
   }
   ```

3. **Update docker-compose-nginx.yml** - Mount SSL certificates:
   ```yaml
   volumes:
     - /etc/letsencrypt:/etc/letsencrypt:ro
   ```

4. **Access via**: `https://vendor.berkeleyuae.com:8443`

## Alternative: Use Different Ports

If you prefer different ports, update `docker-compose-nginx.yml`:

```yaml
ports:
  - "9000:80"    # Change 8080 to your preferred port
  - "9443:443"   # Change 8443 to your preferred port
```

Then access via: `http://vendor.berkeleyuae.com:9000`

## Important Notes

- ✅ The form will work perfectly on port 8080
- ✅ Users need to include the port number in the URL
- ✅ SSL can be set up on port 8443
- ⚠️ Some users might find the port number in the URL less professional

## Professional Solution: Reverse Proxy

For a cleaner URL without the port number, consider:

1. **Cloudflare** - Free reverse proxy with SSL
2. **Another Nginx instance** - On a different server/port that forwards to 8080
3. **Load Balancer** - If you have infrastructure for it

---

**Current Access URL**: `http://vendor.berkeleyuae.com:8080`



