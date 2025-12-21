# Add Cloudflare Tunnel Route for vendor.berkeleyuae.com

## Current Status
- ✅ Tunnel exists: "odoo" 
- ❌ No hostname routes configured
- ❌ Route for `vendor.berkeleyuae.com` is missing

## Steps to Add the Route

### Step 1: Click "Add hostname route" Button

In the Cloudflare dashboard you're viewing:
1. Click the blue **"+ Add hostname route"** button

### Step 2: Configure the Route

Fill in the form:

**Hostname:**
- Enter: `vendor.berkeleyuae.com`

**Service:**
- Select: `HTTP`
- Enter: `http://localhost:9000`

**Path (optional):**
- Leave empty (to route all paths)

**Description (optional):**
- Enter: `Vendor Registration Form`

### Step 3: Save

Click **Save** or **Add route**

## Important Notes

### Verify Tunnel ID
Make sure you're adding the route to the correct tunnel. The tunnel should be:
- **Tunnel ID**: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
- **Tunnel Name**: "odoo" (as shown in your screenshot)

If you're not sure, check the tunnel overview page to verify the tunnel ID matches.

### Service URL
The service URL must be:
- `http://localhost:9000` (not `https://`)
- This is the nginx container that's exposed on port 9000

### After Adding the Route

1. **Wait 1-2 minutes** for the route to propagate

2. **Test DNS:**
   ```powershell
   nslookup vendor.berkeleyuae.com
   ```
   Should resolve to the Cloudflare tunnel

3. **Test the endpoint:**
   ```powershell
   curl https://vendor.berkeleyuae.com/api/health
   ```

4. **Test in browser:**
   ```
   https://vendor.berkeleyuae.com
   ```

## Troubleshooting

### If the route doesn't work:

1. **Verify services are running:**
   ```powershell
   docker ps
   ```
   Should show: `vendor-form-backend`, `vendor-form-nginx`

2. **Test localhost:9000:**
   ```powershell
   curl http://localhost:9000/api/health
   ```
   Should return: `{"status":"ok",...}`

3. **Check tunnel logs:**
   ```powershell
   docker logs cloudflared-tunnel
   ```

4. **Verify DNS record exists:**
   - If `berkeleyuae.com` is on Cloudflare: Check DNS records
   - If NOT on Cloudflare: Add CNAME at domain registrar

### If DNS still doesn't resolve:

You may also need to add a DNS record:

**If berkeleyuae.com is on Cloudflare:**
1. Go to: Cloudflare Dashboard → `berkeleyuae.com` → DNS → Records
2. Add CNAME:
   - Name: `vendor`
   - Target: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
   - Proxy: Proxied (orange cloud)

**If berkeleyuae.com is NOT on Cloudflare:**
1. Go to your domain registrar
2. Add CNAME:
   - Host: `vendor`
   - Target: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`

## Quick Checklist

- [ ] Click "+ Add hostname route" in Cloudflare dashboard
- [ ] Enter hostname: `vendor.berkeleyuae.com`
- [ ] Enter service: `http://localhost:9000`
- [ ] Save the route
- [ ] Verify DNS record exists (if needed)
- [ ] Test: `curl https://vendor.berkeleyuae.com/api/health`
- [ ] Test in browser: `https://vendor.berkeleyuae.com`

## Expected Result

After adding the route, the "Hostname routes" table should show:
- **Hostname**: `vendor.berkeleyuae.com`
- **Description**: (whatever you entered)

And the domain should be accessible!


