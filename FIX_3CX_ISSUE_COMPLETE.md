# Complete Fix: Still Seeing 3CX on vendor.berkeleyuae.com

## The Problem

You're still seeing 3CX because the **Cloudflare route hasn't been updated** to port 9000, OR the services aren't running.

## Step 1: Verify Services Are Running

### Check if containers are running:

Open **Command Prompt** (not PowerShell) and run:

```cmd
docker ps --filter "name=vendor-form"
```

**Expected output:**
```
CONTAINER ID   IMAGE                                          STATUS         PORTS
xxxxx          berkeleysvendorregistrationform-form-backend   Up X minutes   127.0.0.1:3001->3000/tcp
xxxxx          nginx:alpine                                  Up X minutes   0.0.0.0:9000->80/tcp
```

**If you see nothing or containers are stopped:**
```cmd
cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"
docker-compose -f docker-compose-nginx.yml up -d
```

### Test port 9000 locally:

```cmd
curl http://localhost:9000/api/health
```

**Expected response:**
```json
{"status":"ok","timestamp":"..."}
```

**If this doesn't work**, services aren't running correctly.

## Step 2: Update Cloudflare Route (CRITICAL!)

The Cloudflare route is probably still pointing to the wrong port. You **MUST** update it:

### Detailed Steps:

1. **Go to Cloudflare Dashboard**
   - URL: https://dash.cloudflare.com
   - Login to your account

2. **Navigate to Zero Trust**
   - Click **Zero Trust** in left sidebar
   - If you don't see it: Click **More Products** → **Zero Trust**

3. **Go to Networks → Tunnels**
   - Click **Networks** in left sidebar
   - Click **Tunnels**

4. **Find Your Tunnel**
   - You'll see your tunnel listed
   - Click on the tunnel name (not the settings icon, the name itself)

5. **Find vendor.berkeleyuae.com Route**
   - Scroll to "Public hostnames" section
   - Find `vendor.berkeleyuae.com`
   - Click **Edit** (pencil icon) next to it

6. **Update Service URL**
   - Look for **Service** or **Service URL** field
   - **Current (WRONG)**: Probably shows:
     - `http://localhost:8080` ❌
     - `https://localhost:443` ❌
     - `https://localhost:8443` ❌
   - **Change to (CORRECT)**:
     - `http://localhost:9000` ✅
   - **IMPORTANT:**
     - Use **HTTP** (not HTTPS)
     - Use port **9000** (not 8080, not 443, not 8443)

7. **Save**
   - Click **Save** or **Update**
   - Wait for confirmation

8. **Wait 2-3 minutes** for Cloudflare to propagate the change

## Step 3: Clear Browser Cache

After updating Cloudflare:

1. **Hard refresh:**
   - Press `Ctrl + Shift + R` or `Ctrl + F5`

2. **Or clear cache:**
   - Press `Ctrl + Shift + Delete`
   - Select "Cached images and files"
   - Time range: "All time"
   - Click "Clear data"

3. **Or use incognito/private mode:**
   - Chrome/Edge: `Ctrl + Shift + N`
   - Firefox: `Ctrl + Shift + P`

4. **Visit:** `https://vendor.berkeleyuae.com`

## Step 4: Verify Everything

### Checklist:

- [ ] Docker containers are running (`docker ps` shows both containers)
- [ ] Port 9000 responds locally (`curl http://localhost:9000/api/health` works)
- [ ] Cloudflare route updated to `http://localhost:9000`
- [ ] Waited 2-3 minutes after updating Cloudflare
- [ ] Cleared browser cache or using incognito mode
- [ ] Still seeing 3CX? → Check Cloudflare route again

## Common Issues

### Issue 1: Route Still Points to Port 8080

**Symptom:** Updated route but still seeing 3CX

**Fix:**
- Double-check the route in Cloudflare
- Make sure it says `http://localhost:9000` (not 8080, not 443)
- Save again
- Wait longer (up to 5 minutes)

### Issue 2: Services Not Running

**Symptom:** `docker ps` shows no containers or containers are stopped

**Fix:**
```cmd
cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"
docker-compose -f docker-compose-nginx.yml down
docker-compose -f docker-compose-nginx.yml up -d
docker ps
```

### Issue 3: Port 9000 Not Responding

**Symptom:** `curl http://localhost:9000/api/health` fails

**Fix:**
```cmd
# Check logs
docker logs vendor-form-nginx
docker logs vendor-form-backend

# Restart
docker-compose -f docker-compose-nginx.yml restart
```

### Issue 4: Browser Cache

**Symptom:** Updated everything but still seeing 3CX

**Fix:**
- Use incognito/private mode
- Or clear cache completely
- Or try a different browser

## Quick Verification Commands

Run these in Command Prompt to verify everything:

```cmd
REM 1. Check containers
docker ps --filter "name=vendor-form"

REM 2. Test port 9000
curl http://localhost:9000/api/health

REM 3. Check nginx logs
docker logs vendor-form-nginx --tail 20

REM 4. Check backend logs
docker logs vendor-form-backend --tail 20
```

## Most Likely Issue

**The Cloudflare route is still pointing to port 8080 or 443 (3CX).**

**Solution:** Update it to `http://localhost:9000` in Cloudflare Dashboard.

---

**After updating Cloudflare route to port 9000 and waiting 2-3 minutes, you should see the vendor form instead of 3CX!**



