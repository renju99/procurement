# Create DNS CNAME for Cloudflare Tunnel

## Current Status

✅ A record deleted (good!)
❌ DNS not resolving (needs CNAME)

## Solution: Create CNAME Record

You need to manually create a CNAME record pointing to your Cloudflare Tunnel.

## Step 1: Find Your Tunnel CNAME Target

### Method 1: From Tunnel Details

1. Go to **Cloudflare Dashboard** → **Zero Trust** → **Networks** → **Tunnels**
2. Click on your tunnel (the "odoo" tunnel)
3. Look for **"Tunnel ID"** or check the tunnel name
4. The CNAME target will be: `[tunnel-id].cfargotunnel.com`

### Method 2: Check Other Routes

Since you have other routes working (like `sentry.proptechme.com`), check their DNS:

1. Go to **Cloudflare Dashboard** → **DNS** → **Records**
2. Look for `sentry.proptechme.com` or any other working subdomain
3. See what CNAME target they use
4. Use the same pattern for `vendor`

### Method 3: From Tunnel Route Configuration

1. In Tunnel settings, look at the route configuration
2. The tunnel should have a unique identifier
3. Format: `[uuid].cfargotunnel.com`

## Step 2: Create CNAME Record

1. Go to **Cloudflare Dashboard** → Your domain (`berkeleyuae.com`)
2. Click **DNS** → **Records**
3. Click **Add record**
4. Fill in:
   - **Type**: `CNAME`
   - **Name**: `vendor`
   - **Target**: `[your-tunnel-id].cfargotunnel.com`
     - Replace `[your-tunnel-id]` with the actual tunnel ID from Step 1
   - **Proxy status**: **Proxied** (orange cloud) ✅ **IMPORTANT!**
   - **TTL**: Auto
5. Click **Save**

## Step 3: Alternative - Use Cloudflare Tunnel DNS Command

If you have access to the server running the tunnel, you can use:

```bash
cloudflared tunnel route dns vendor-form-tunnel vendor.berkeleyuae.com
```

This will automatically create the CNAME record.

## Step 4: Verify DNS

Wait 5-10 minutes, then check:

```cmd
nslookup vendor.berkeleyuae.com
```

**Should now show:**
- Cloudflare IP addresses (like 104.x.x.x or 172.x.x.x)
- NOT "Non-existent domain"

## What the CNAME Target Looks Like

The CNAME target will be something like:
- `a1b2c3d4-e5f6-7890-abcd-ef1234567890.cfargotunnel.com`
- Or similar format with tunnel UUID

## If You Can't Find Tunnel ID

1. **Check tunnel name:**
   - Your tunnel is called "odoo" (from the screenshot)
   - The tunnel ID is usually shown in the tunnel details page

2. **Check existing DNS for other subdomains:**
   - Look at `sentry.proptechme.com` DNS record
   - See what CNAME target it uses
   - Use the same tunnel ID for `vendor`

3. **Contact Cloudflare support** if you can't find it

## Quick Check: Is Domain on Cloudflare?

Make sure `berkeleyuae.com` is:
- ✅ Added to your Cloudflare account
- ✅ Using Cloudflare nameservers
- ✅ DNS is managed by Cloudflare

If not, you'll need to:
1. Add domain to Cloudflare
2. Update nameservers at your registrar
3. Then create the CNAME record

---

**Once the CNAME is created and DNS propagates, vendor.berkeleyuae.com will work through Cloudflare Tunnel!**



