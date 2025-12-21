# Update Cloudflare Route - Step by Step

## The Problem

You're seeing 3CX because the Cloudflare Tunnel route is pointing to port **443** (3CX) instead of port **8080** (your vendor form).

## Solution: Update the Route

### Step-by-Step Instructions

1. **Open Cloudflare Dashboard**
   - Go to: https://dash.cloudflare.com
   - Login to your account

2. **Navigate to Zero Trust**
   - Click on **Zero Trust** in the left sidebar
   - If you don't see it, click **More Products** → **Zero Trust**

3. **Go to Networks → Tunnels**
   - Click **Networks** in the left sidebar
   - Click **Tunnels**

4. **Find Your Tunnel**
   - You should see your tunnel listed (the one that's running)
   - Click on the tunnel name to open it

5. **Find the Route for vendor.berkeleyuae.com**
   - Look for `vendor.berkeleyuae.com` in the "Public hostnames" section
   - Click **Edit** (or the pencil icon) next to it

6. **Update the Service URL**
   - Find the **Service URL** field
   - **Current (Wrong)**: Probably `https://localhost:443` or `https://localhost:8443`
   - **Change to (Correct)**: `http://localhost:8080`
   - **Important**: 
     - Use **HTTP** (not HTTPS)
     - Use port **8080** (not 443, not 8443)

7. **Save the Changes**
   - Click **Save** or **Update**
   - Wait 1-2 minutes for changes to propagate

8. **Test**
   - Clear browser cache (Ctrl+Shift+Delete)
   - Or use incognito/private mode
   - Visit: **https://vendor.berkeleyuae.com**
   - Should now show the vendor registration form!

## Visual Guide

```
Cloudflare Dashboard
  └─ Zero Trust
      └─ Networks
          └─ Tunnels
              └─ [Your Tunnel Name]
                  └─ Public hostnames
                      └─ vendor.berkeleyuae.com
                          └─ Edit
                              └─ Service URL: http://localhost:8080 ✅
```

## What to Look For

### ❌ Wrong Configuration:
- Service URL: `https://localhost:443` (3CX)
- Service URL: `https://localhost:8443`
- Service URL: `http://localhost:80` (might also be 3CX)

### ✅ Correct Configuration:
- Service URL: `http://localhost:8080`
- Service Type: `HTTP` (not HTTPS)
- Port: `8080`

## Verify Services Are Running First

Before updating the route, make sure your services are running:

```powershell
# Check containers
docker ps

# Should show:
# vendor-form-nginx - with port 0.0.0.0:8080->80/tcp
# vendor-form-backend - running

# Test local access
curl http://localhost:8080/api/health
```

If services aren't running:
```powershell
docker-compose -f docker-compose-nginx.yml up -d
```

## After Updating Route

1. **Wait 1-2 minutes** for Cloudflare to update
2. **Clear browser cache** or use incognito mode
3. **Test**: Visit `https://vendor.berkeleyuae.com`
4. **Should see**: Vendor registration form (not 3CX login)

## Troubleshooting

### Still seeing 3CX after update?
- Wait another minute (propagation can take time)
- Clear browser cache completely
- Try a different browser or incognito mode
- Check route was saved correctly in Cloudflare

### Route won't save?
- Make sure you're using HTTP (not HTTPS) for localhost
- Port must be 8080
- Service type should be "HTTP"

### Services not running?
- Run: `docker-compose -f docker-compose-nginx.yml up -d`
- Check logs: `docker logs vendor-form-nginx`

---

**The fix is simple: Change the Cloudflare route from port 443/8443 to port 8080!**



