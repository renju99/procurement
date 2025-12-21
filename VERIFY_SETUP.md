# Verify Vendor Form Setup

## ✅ Cloudflare Tunnel Configuration

Great news! Your Cloudflare Tunnel is already configured:
- **Route**: `vendor.berkeleyuae.com` → `http://localhost:8080`
- This means the tunnel will forward traffic from `vendor.berkeleyuae.com` to your local port 8080

## Current Status Check

### 1. Verify Docker Services Are Running

```powershell
docker ps
```

You should see:
- `vendor-form-backend` - Running
- `vendor-form-nginx` - Running on port 8080

### 2. Test Local Access

```powershell
# Test nginx on port 8080
Invoke-WebRequest -Uri http://localhost:8080/api/health

# Should return: {"status":"ok","timestamp":"..."}
```

### 3. Test via Cloudflare Tunnel

Open in browser:
**https://vendor.berkeleyuae.com**

You should see the vendor registration form (not the 3CX login page).

## If Services Aren't Running

### Start Services:

```powershell
# Navigate to project directory
cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"

# Start services
docker-compose -f docker-compose-nginx.yml up -d

# Check status
docker ps
```

### Verify Nginx is on Port 8080:

```powershell
# Check if port 8080 is listening
netstat -ano | findstr :8080

# Test nginx
Invoke-WebRequest -Uri http://localhost:8080
```

## Troubleshooting

### Issue: Can't access vendor.berkeleyuae.com

**Check 1: Is nginx running on port 8080?**
```powershell
docker logs vendor-form-nginx
```

**Check 2: Is backend running?**
```powershell
docker logs vendor-form-backend
```

**Check 3: Test localhost:8080 directly**
```powershell
Invoke-WebRequest -Uri http://localhost:8080/api/health
```

If this works but Cloudflare doesn't, check:
- Cloudflare Tunnel status in dashboard
- DNS propagation (wait 1-2 minutes)

### Issue: Still seeing 3CX login page

This means the route is pointing to the wrong service. Since you can't change router rules, the Cloudflare Tunnel route should be correct.

**Verify the route in Cloudflare:**
- Go to Zero Trust → Networks → Tunnels
- Check that `vendor.berkeleyuae.com` routes to `http://localhost:8080`
- Make sure it's NOT routing to port 443 or 80 (those are 3CX)

### Issue: Port 8080 already in use

If port 8080 is also in use, you can:

1. **Change to a different port** (e.g., 9000):
   - Edit `docker-compose-nginx.yml`: Change `"8080:80"` to `"9000:80"`
   - Update Cloudflare route: `vendor.berkeleyuae.com` → `http://localhost:9000`
   - Restart: `docker-compose -f docker-compose-nginx.yml restart`

2. **Or use port 3001 directly** (bypass nginx):
   - Update Cloudflare route: `vendor.berkeleyuae.com` → `http://localhost:3001`
   - This works but you lose nginx features (better to use nginx)

## Expected Behavior

✅ **Working correctly:**
- `https://vendor.berkeleyuae.com` → Shows vendor registration form
- Form submission works
- No port numbers in URL
- HTTPS automatically provided by Cloudflare

❌ **Not working:**
- Shows 3CX login → Route is wrong or nginx not on 8080
- Connection refused → Services not running
- 404 error → Backend not accessible

## Quick Commands

```powershell
# Start services
docker-compose -f docker-compose-nginx.yml up -d

# View logs
docker logs vendor-form-nginx
docker logs vendor-form-backend

# Restart services
docker-compose -f docker-compose-nginx.yml restart

# Stop services
docker-compose -f docker-compose-nginx.yml down

# Test locally
Invoke-WebRequest -Uri http://localhost:8080/api/health
```

---

**Your setup is almost complete!** Just make sure the Docker services are running on port 8080, and you should be able to access the form at `https://vendor.berkeleyuae.com` 🎉



