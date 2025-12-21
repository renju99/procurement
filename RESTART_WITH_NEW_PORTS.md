# Restart Services with New Port Configuration

## ✅ Configuration Updated

The Docker configuration has been updated to use:
- **Port 8080** for HTTP (instead of 80)
- **Port 8443** for HTTPS (instead of 443)

## Commands to Run

Open PowerShell or Command Prompt in the project directory and run:

### Step 1: Stop Current Services
```powershell
docker-compose -f docker-compose-nginx.yml down
```

### Step 2: Start Services with New Ports
```powershell
docker-compose -f docker-compose-nginx.yml up -d
```

### Step 3: Verify Services Are Running
```powershell
docker ps
```

You should see:
- `vendor-form-backend` - Running
- `vendor-form-nginx` - Running on ports 8080 and 8443

### Step 4: Test the Form

Open in your browser:
**http://vendor.berkeleyuae.com:8080**

Or test via PowerShell:
```powershell
Invoke-WebRequest -Uri http://vendor.berkeleyuae.com:8080/api/health
```

## Access URLs

- **Form**: `http://vendor.berkeleyuae.com:8080`
- **API Health**: `http://vendor.berkeleyuae.com:8080/api/health`
- **API Submit**: `http://vendor.berkeleyuae.com:8080/api/submit`

## Troubleshooting

If you get port conflicts:

1. **Check what's using port 8080:**
   ```powershell
   netstat -ano | findstr :8080
   ```

2. **If port 8080 is also in use**, edit `docker-compose-nginx.yml` and change:
   ```yaml
   ports:
     - "9000:80"    # Use port 9000 instead
     - "9443:443"   # Use port 9443 instead
   ```

3. **Then restart:**
   ```powershell
   docker-compose -f docker-compose-nginx.yml restart
   ```

## Check Logs

If something isn't working:

```powershell
# Nginx logs
docker logs vendor-form-nginx

# Backend logs
docker logs vendor-form-backend
```

---

**After restarting, access the form at: `http://vendor.berkeleyuae.com:8080`**



