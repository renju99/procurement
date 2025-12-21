# Complete Cloudflare Route Setup

## Current Step: Create Hostname Route

You're on the "Create a new hostname route" form. Here's what to do:

### Step 1: Verify Hostname
- ✅ Hostname: `vendor.berkeleyuae.com` (already filled)
- Description: You can change "website hostname" to something like "Vendor Registration Form" (optional)

### Step 2: Click "Create"
Click the blue **"Create"** button at the bottom right.

### Step 3: Configure Service (Next Step)
After clicking "Create", you'll likely see another screen or form where you need to configure:

**Service URL:**
- Type: `HTTP`
- URL: `http://localhost:9000`

**Important:** Make sure the service points to `http://localhost:9000` (this is where your nginx container is running).

## What to Expect

### If you see a service configuration screen:
1. Select service type: **HTTP** or **HTTPS** → **HTTP**
2. Enter service URL: `http://localhost:9000`
3. Path (optional): Leave empty
4. Click **Save** or **Continue**

### If the route is created immediately:
1. You may need to edit it to add the service
2. Go back to the hostname routes list
3. Click on `vendor.berkeleyuae.com`
4. Add/edit the service configuration

## After Configuration

### 1. Verify the Route
Go back to the hostname routes list. You should see:
- **Hostname**: `vendor.berkeleyuae.com`
- **Service**: `http://localhost:9000` (or similar)

### 2. Wait for Propagation
Wait 1-2 minutes for the route to activate.

### 3. Test DNS
```powershell
nslookup vendor.berkeleyuae.com
```
Should resolve to: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`

### 4. Test the Endpoint
```powershell
curl https://vendor.berkeleyuae.com/api/health
```

### 5. Test in Browser
```
https://vendor.berkeleyuae.com
```

## Important Notes

### Service URL Must Be Correct
- ✅ Correct: `http://localhost:9000`
- ❌ Wrong: `https://localhost:9000` (no https)
- ❌ Wrong: `http://vendor-form-nginx:80` (won't work with network_mode: host)
- ❌ Wrong: `http://127.0.0.1:9000` (localhost is preferred)

### Why localhost:9000?
- Your nginx container is exposed on `127.0.0.1:9000:80`
- The guardpro cloudflared tunnel uses `network_mode: host`
- With host networking, it can access `localhost:9000`

### If Service Configuration Isn't Visible
Some Cloudflare interfaces show service configuration in a different step:
1. After creating the hostname route
2. In the route details/edit page
3. As a separate "Add service" action

Look for:
- "Add service" button
- "Configure service" link
- Edit icon next to the route
- Service configuration in route details

## Troubleshooting

### If you can't find where to add the service:
1. **Check the route details page:**
   - Click on `vendor.berkeleyuae.com` in the routes list
   - Look for "Service" or "Backend" configuration

2. **Check if it's a different interface:**
   - Some tunnels use "Public Hostname" instead of "Hostname routes"
   - Look for tabs: "Public Hostname", "Private Hostname", or "Routes"

3. **Alternative: Use Public Hostname tab:**
   - Go to tunnel overview
   - Click "Public Hostname" tab
   - Add: `vendor.berkeleyuae.com` → `http://localhost:9000`

## Quick Action

**Right now:**
1. ✅ Hostname is filled: `vendor.berkeleyuae.com`
2. Click **"Create"** button
3. Look for service configuration (next screen or edit route)
4. Set service to: `http://localhost:9000`
5. Save/Complete

## Next Steps After Setup

Once the route is configured:

1. **Ensure services are running:**
   ```powershell
   docker ps
   ```
   Should show: `vendor-form-backend`, `vendor-form-nginx`

2. **Test locally first:**
   ```powershell
   curl http://localhost:9000/api/health
   ```

3. **Then test publicly:**
   ```powershell
   curl https://vendor.berkeleyuae.com/api/health
   ```

4. **Open in browser:**
   ```
   https://vendor.berkeleyuae.com
   ```

You should see the vendor registration form!


