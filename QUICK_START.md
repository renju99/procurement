# Quick Start - Vendor Form Services

## ✅ Everything is Configured!

Your setup is complete:
- ✅ Cloudflare Tunnel: `vendor.berkeleyuae.com` → `localhost:8080`
- ✅ Docker configuration: Nginx on port 8080
- ✅ No router changes needed

## Start Services

### Option 1: Run the Batch Script (Easiest)

Double-click: **`start-vendor-form.bat`**

This will:
1. Stop any existing containers
2. Start the services
3. Show status
4. Test the endpoint

### Option 2: Manual Commands

Open PowerShell or Command Prompt in this directory and run:

```powershell
# Start services
docker-compose -f docker-compose-nginx.yml up -d

# Check status
docker ps

# Test local endpoint
curl http://localhost:8080/api/health
```

## Verify Everything Works

### 1. Check Services Are Running

```powershell
docker ps
```

You should see:
- `vendor-form-backend` - Status: Up
- `vendor-form-nginx` - Status: Up, Ports: 0.0.0.0:8080->80/tcp

### 2. Test Local Access

```powershell
# Test API health endpoint
curl http://localhost:8080/api/health

# Should return: {"status":"ok","timestamp":"..."}
```

### 3. Access via Cloudflare

Open in browser:
**https://vendor.berkeleyuae.com**

You should see the **vendor registration form** (not 3CX login).

## Troubleshooting

### Services Won't Start?

```powershell
# Check for errors
docker-compose -f docker-compose-nginx.yml logs

# Check if port 8080 is in use
netstat -ano | findstr :8080
```

### Still Seeing 3CX Login?

1. **Verify Cloudflare route:**
   - Go to Cloudflare Dashboard → Zero Trust → Networks → Tunnels
   - Check `vendor.berkeleyuae.com` routes to `http://localhost:8080`
   - NOT `https://localhost:8443` or port 443

2. **Verify services are on port 8080:**
   ```powershell
   docker ps
   # Should show: 0.0.0.0:8080->80/tcp for nginx
   ```

3. **Test locally first:**
   ```powershell
   curl http://localhost:8080
   # Should show the vendor form HTML
   ```

### View Logs

```powershell
# Nginx logs
docker logs vendor-form-nginx

# Backend logs
docker logs vendor-form-backend

# Follow logs in real-time
docker logs -f vendor-form-nginx
```

## Quick Commands Reference

```powershell
# Start services
docker-compose -f docker-compose-nginx.yml up -d

# Stop services
docker-compose -f docker-compose-nginx.yml down

# Restart services
docker-compose -f docker-compose-nginx.yml restart

# View logs
docker logs vendor-form-nginx
docker logs vendor-form-backend

# Check status
docker ps
```

## Success Indicators

✅ **Working correctly:**
- `docker ps` shows both containers running
- `curl http://localhost:8080/api/health` returns JSON
- `https://vendor.berkeleyuae.com` shows vendor form
- Form submission works

❌ **Not working:**
- Containers not running → Run `start-vendor-form.bat`
- Port 8080 in use → Check what's using it
- Still seeing 3CX → Verify Cloudflare route points to port 8080

---

**Ready to go!** Just run `start-vendor-form.bat` or the docker-compose command, then access `https://vendor.berkeleyuae.com` 🚀



