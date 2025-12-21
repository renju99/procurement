# Manual Verification Steps

Since automated verification has issues, please run these commands manually in your terminal:

## Step 1: Check if Services Are Running

Open PowerShell or Command Prompt and run:

```powershell
docker ps
```

**Look for these containers:**
- ✅ `vendor-form-backend` - Should be running
- ✅ `vendor-form-nginx` - Should be running  
- ✅ `cloudflared-tunnel` - Should be running (guardpro's tunnel)
- ❌ `vendor-form-cloudflared` - Should NOT exist

## Step 2: Start Services (If Not Running)

If services aren't running, start them:

```powershell
cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"
docker-compose -f docker-compose-cloudflare.yml up -d
```

Wait a few seconds, then check again:
```powershell
docker ps
```

## Step 3: Test Localhost:9000

Test if nginx is accessible locally:

```powershell
curl http://localhost:9000/api/health
```

**Expected response:**
```json
{"status":"ok","timestamp":"2024-..."}
```

**If it fails:**
- Check nginx logs: `docker logs vendor-form-nginx`
- Check backend logs: `docker logs vendor-form-backend`

## Step 4: Test Public Domain

Test the public domain:

```powershell
curl https://vendor.berkeleyuae.com/api/health
```

**Expected response:**
```json
{"status":"ok","timestamp":"2024-..."}
```

**Or open in browser:**
```
https://vendor.berkeleyuae.com/api/health
```

## Step 5: Test the Form

Open in browser:
```
https://vendor.berkeleyuae.com
```

You should see the vendor registration form.

## Troubleshooting

### If localhost:9000 doesn't work:

1. **Check if nginx container is running:**
   ```powershell
   docker ps | findstr vendor-form-nginx
   ```

2. **Check nginx logs:**
   ```powershell
   docker logs vendor-form-nginx
   ```

3. **Check backend logs:**
   ```powershell
   docker logs vendor-form-backend
   ```

4. **Restart services:**
   ```powershell
   docker-compose -f docker-compose-cloudflare.yml restart
   ```

### If public domain doesn't work:

1. **Verify Cloudflare route:**
   - Go to: https://one.dash.cloudflare.com
   - Navigate to: Zero Trust → Networks → Tunnels
   - Find tunnel: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
   - Check Public Hostname tab
   - Verify: `vendor.berkeleyuae.com` → `http://localhost:9000`

2. **Check tunnel logs:**
   ```powershell
   docker logs cloudflared-tunnel
   ```

3. **Verify DNS (already done):**
   ```powershell
   nslookup vendor.berkeleyuae.com
   ```
   Should show: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`

## Quick Status Check

Run this to see all vendor-form related containers:

```powershell
docker ps -a | findstr vendor-form
```

## Summary Checklist

- [ ] DNS resolves correctly (✅ Already verified)
- [ ] `vendor-form-backend` container is running
- [ ] `vendor-form-nginx` container is running
- [ ] `cloudflared-tunnel` container is running
- [ ] `localhost:9000/api/health` returns OK
- [ ] `https://vendor.berkeleyuae.com/api/health` returns OK
- [ ] `https://vendor.berkeleyuae.com` shows the form

## Quick Commands Reference

```powershell
# Check status
docker ps

# Start services
docker-compose -f docker-compose-cloudflare.yml up -d

# View logs
docker logs vendor-form-backend
docker logs vendor-form-nginx
docker logs cloudflared-tunnel

# Test endpoints
curl http://localhost:9000/api/health
curl https://vendor.berkeleyuae.com/api/health

# Restart services
docker-compose -f docker-compose-cloudflare.yml restart

# Stop services
docker-compose -f docker-compose-cloudflare.yml down
```


