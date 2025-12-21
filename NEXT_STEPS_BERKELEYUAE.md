# Next Steps for vendor.berkeleyuae.com

## ✅ Completed Steps

1. ✅ DNS Record Updated - `vendor.berkeleyuae.com` → `83.110.23.106`
2. ✅ DNS Verified - Domain is resolving correctly
3. ✅ Configuration Updated - All nginx configs updated to use `vendor.berkeleyuae.com`
4. ✅ Docker Services Started - Backend and Nginx containers are running

## 🔄 Current Status

The services have been started. Now you need to verify everything is working.

## Step 1: Verify Services Are Running

Open PowerShell or Command Prompt and run:

```powershell
docker ps
```

You should see:
- `vendor-form-backend` - Running on port 3001
- `vendor-form-nginx` - Running on ports 80 and 443

## Step 2: Check Nginx Logs

```powershell
docker logs vendor-form-nginx
```

Look for any errors. If you see errors about port 80 being in use, you may need to stop other services using port 80.

## Step 3: Test the Domain

### Test HTTP (from your server or local machine):

```powershell
# Test if the domain is accessible
Invoke-WebRequest -Uri http://vendor.berkeleyuae.com -Method GET

# Or test the API endpoint
Invoke-WebRequest -Uri http://vendor.berkeleyuae.com/api/health -Method GET
```

### Or open in browser:
- Navigate to: **http://vendor.berkeleyuae.com**
- You should see the vendor registration form

## Step 4: Test Form Submission

1. Open `http://vendor.berkeleyuae.com` in your browser
2. Fill out a test submission
3. Verify it submits successfully

## Step 5: Set Up SSL (HTTPS) - Highly Recommended

### Option A: Using Certbot (if running on Linux server)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d vendor.berkeleyuae.com

# Certbot will automatically configure nginx
```

### Option B: For Docker with SSL

1. **Get certificate on host:**
   ```bash
   sudo certbot certonly --standalone -d vendor.berkeleyuae.com
   ```

2. **Update docker-compose-nginx.yml** - Uncomment the SSL volume:
   ```yaml
   nginx:
     volumes:
       - ./nginx-docker.conf:/etc/nginx/conf.d/default.conf:ro
       - ./nginx-logs:/var/log/nginx
       - /etc/letsencrypt:/etc/letsencrypt:ro  # Uncomment this line
   ```

3. **Add SSL configuration to nginx-docker.conf:**
   
   Add this after the HTTP server block:
   ```nginx
   server {
       listen 443 ssl http2;
       server_name vendor.berkeleyuae.com;
   
       ssl_certificate /etc/letsencrypt/live/vendor.berkeleyuae.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/vendor.berkeleyuae.com/privkey.pem;
       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_ciphers HIGH:!aNULL:!MD5;
       ssl_prefer_server_ciphers on;
   
       location / {
           proxy_pass http://form-backend:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_cache_bypass $http_upgrade;
           
           proxy_read_timeout 300s;
           proxy_connect_timeout 300s;
           proxy_send_timeout 300s;
           client_max_body_size 50M;
       }
   }
   ```

4. **Restart Docker:**
   ```powershell
   docker-compose -f docker-compose-nginx.yml restart
   ```

## Troubleshooting

### Port 80 Already in Use

If you get an error that port 80 is already in use:

1. **Find what's using port 80:**
   ```powershell
   netstat -ano | findstr :80
   ```

2. **Stop the conflicting service** or change nginx to use a different port temporarily

### Nginx Container Not Starting

```powershell
# Check logs
docker logs vendor-form-nginx

# Check if nginx config is valid
docker exec vendor-form-nginx nginx -t
```

### Backend Not Responding

```powershell
# Check backend logs
docker logs vendor-form-backend

# Test backend directly
Invoke-WebRequest -Uri http://localhost:3001/api/health
```

### Domain Not Accessible

1. **Verify DNS is still resolving:**
   ```powershell
   nslookup vendor.berkeleyuae.com
   ```

2. **Check firewall** - Make sure ports 80 and 443 are open

3. **Check if server is accessible:**
   ```powershell
   Test-NetConnection -ComputerName vendor.berkeleyuae.com -Port 80
   ```

## Quick Commands Reference

```powershell
# View running containers
docker ps

# View logs
docker logs vendor-form-nginx
docker logs vendor-form-backend

# Restart services
docker-compose -f docker-compose-nginx.yml restart

# Stop services
docker-compose -f docker-compose-nginx.yml down

# Start services
docker-compose -f docker-compose-nginx.yml up -d

# View all containers (including stopped)
docker ps -a
```

## Verification Checklist

- [ ] DNS resolves correctly (`nslookup vendor.berkeleyuae.com`)
- [ ] Docker containers are running (`docker ps`)
- [ ] Can access form via HTTP (`http://vendor.berkeleyuae.com`)
- [ ] Form submission works
- [ ] SSL certificate obtained (optional but recommended)
- [ ] HTTPS works (`https://vendor.berkeleyuae.com`)

## Success!

Once all steps are complete:
- ✅ Users can access the form at `http://vendor.berkeleyuae.com` (or `https://` with SSL)
- ✅ The proptechme.com domain is hidden
- ✅ Form submissions work correctly
- ✅ All files are stored properly

---

**Need Help?** Check the logs if something isn't working:
- `docker logs vendor-form-nginx` - Nginx logs
- `docker logs vendor-form-backend` - Backend logs



