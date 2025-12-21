# Fix: Still Seeing 3CX Login Page

If you're still seeing the 3CX login page, the Cloudflare Tunnel route is likely pointing to the wrong port.

## The Problem

The Cloudflare route might be pointing to:
- Port **443** (3CX HTTPS) ❌
- Port **80** (3CX HTTP) ❌
- Instead of port **8080** (your vendor form) ✅

## Solution: Update Cloudflare Route

### Step 1: Check Current Route

1. Go to **Cloudflare Dashboard** → **Zero Trust** → **Networks** → **Tunnels**
2. Click on your tunnel
3. Find the route for `vendor.berkeleyuae.com`
4. Check what port it's pointing to

### Step 2: Update the Route

**Option A: Edit Existing Route**

1. Click **Edit** on the `vendor.berkeleyuae.com` route
2. Change the **Service URL** from:
   - `https://localhost:8443` ❌ (or any other port)
   - To: `http://localhost:8080` ✅
3. Make sure it's **HTTP** (not HTTPS) and port **8080**
4. Click **Save**

**Option B: Delete and Recreate Route**

1. Delete the existing `vendor.berkeleyuae.com` route
2. Add a new **Public Hostname**:
   - **Subdomain**: `vendor`
   - **Domain**: `berkeleyuae.com`
   - **Service Type**: `HTTP`
   - **Service URL**: `http://localhost:8080` ✅
   - Click **Save**

## Step 3: Verify Services Are Running

Make sure your Docker services are actually running on port 8080:

```powershell
# Check if containers are running
docker ps

# Should show:
# vendor-form-nginx - with port mapping 0.0.0.0:8080->80/tcp
# vendor-form-backend - running

# Test local access
curl http://localhost:8080/api/health
```

If services aren't running, start them:
```powershell
docker-compose -f docker-compose-nginx.yml up -d
```

## Step 4: Wait and Test

1. **Wait 1-2 minutes** for Cloudflare to update the route
2. **Clear your browser cache** (Ctrl+Shift+Delete)
3. **Try incognito/private mode** to bypass cache
4. Access: **https://vendor.berkeleyuae.com**

## Common Issues

### Issue 1: Route Points to Port 443 or 8443
- **Fix**: Change to `http://localhost:8080` (not HTTPS, not 443/8443)

### Issue 2: Route Points to Port 80
- **Fix**: Change to `http://localhost:8080`

### Issue 3: Services Not Running on 8080
- **Fix**: Start services with `docker-compose -f docker-compose-nginx.yml up -d`
- Verify with: `docker ps` (should show port 8080)

### Issue 4: Browser Cache
- **Fix**: Clear cache or use incognito mode

## Verification Checklist

- [ ] Cloudflare route points to `http://localhost:8080` (not https, not 443, not 8443)
- [ ] Docker services are running (`docker ps` shows both containers)
- [ ] Nginx is on port 8080 (`docker ps` shows `0.0.0.0:8080->80/tcp`)
- [ ] Local test works: `curl http://localhost:8080/api/health`
- [ ] Waited 1-2 minutes after updating route
- [ ] Cleared browser cache or used incognito mode

## Quick Test

After updating the route, test locally first:

```powershell
# This should show the vendor form HTML (not 3CX)
curl http://localhost:8080

# This should return JSON
curl http://localhost:8080/api/health
```

If localhost:8080 works but Cloudflare doesn't, the route needs to be updated.

---

**The key is making sure the Cloudflare route points to `http://localhost:8080` (HTTP, port 8080, not HTTPS or port 443/8443)**



