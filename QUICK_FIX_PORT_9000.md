# Quick Fix: Changed to Port 9000

## ✅ What I Changed

1. **Docker configuration**: Changed from port 8080 → **port 9000**
2. **Batch file**: Fixed to stay open and test port 9000
3. **Verification script**: Updated to check port 9000

## ⚠️ IMPORTANT: Update Cloudflare Route

You **MUST** update your Cloudflare Tunnel route:

1. Go to **Cloudflare Dashboard** → **Zero Trust** → **Networks** → **Tunnels**
2. Click your tunnel
3. Find `vendor.berkeleyuae.com` route
4. Click **Edit**
5. Change Service URL from: `http://localhost:8080` 
6. To: `http://localhost:9000` ✅
7. Click **Save**

## Start Services

### Option 1: Run the Fixed Batch File

Double-click: **`START_AND_VERIFY.bat`**

It will now:
- ✅ Stay open (won't close automatically)
- ✅ Test port 9000
- ✅ Show you the results

### Option 2: Manual Commands

```powershell
# Start services
docker-compose -f docker-compose-nginx.yml up -d

# Wait a moment
Start-Sleep -Seconds 10

# Test
curl http://localhost:9000/api/health
```

## After Starting

1. **Update Cloudflare route** to port 9000 (see above)
2. **Wait 1-2 minutes** for Cloudflare to sync
3. **Clear browser cache** (Ctrl+Shift+Delete)
4. **Use incognito mode**
5. **Visit**: `https://vendor.berkeleyuae.com`

## Why Port 9000?

- Port 80 - 3CX
- Port 443 - 3CX
- Port 8080 - Might be in use
- **Port 9000 - Available** ✅

## If Port 9000 is Also in Use

You can change to any other port:

1. Edit `docker-compose-nginx.yml`
2. Change `"9000:80"` to `"YOUR_PORT:80"` (e.g., `"5000:80"`)
3. Update Cloudflare route to match
4. Restart: `docker-compose -f docker-compose-nginx.yml restart`

---

**Remember: Always update BOTH Docker config AND Cloudflare route to the same port!**



