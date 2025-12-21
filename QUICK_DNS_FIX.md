# Quick DNS Fix - Step by Step

## Current Situation

✅ A record deleted
❌ DNS not resolving (needs CNAME)

## Quick Fix (5 minutes)

### Step 1: Get Tunnel ID

1. **Go to Cloudflare Dashboard**
   - https://dash.cloudflare.com
   - Login

2. **Navigate to Tunnels**
   - Click **Zero Trust** (or **More Products** → **Zero Trust**)
   - Click **Networks** → **Tunnels**
   - Click on your tunnel (the one named "odoo" or similar)

3. **Find Tunnel ID**
   - Look for "Tunnel ID" or "Tunnel name"
   - It will be a UUID like: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`
   - The CNAME target will be: `[this-id].cfargotunnel.com`

### Step 2: Create CNAME Record

1. **Go to DNS Settings**
   - Cloudflare Dashboard → `berkeleyuae.com` → **DNS** → **Records**

2. **Add CNAME Record**
   - Click **Add record**
   - **Type**: `CNAME`
   - **Name**: `vendor`
   - **Target**: `[tunnel-id].cfargotunnel.com`
     - Replace `[tunnel-id]` with the actual ID from Step 1
   - **Proxy**: **Proxied** (orange cloud) ✅ **CRITICAL!**
   - **TTL**: Auto
   - Click **Save**

### Step 3: Wait and Test

1. **Wait 5-10 minutes** for DNS propagation

2. **Test DNS:**
   ```cmd
   nslookup vendor.berkeleyuae.com
   ```
   Should now show Cloudflare IPs (not "Non-existent domain")

3. **Test Website:**
   - Clear browser cache
   - Visit: `https://vendor.berkeleyuae.com`
   - Should now go through Cloudflare Tunnel → port 9000 → vendor form!

## Alternative: Check Existing Routes

If you can't find the tunnel ID, check an existing working route:

1. **Check DNS for another subdomain:**
   - Go to DNS → Records
   - Look at `sentry.proptechme.com` or `meal.proptechme.com`
   - See what CNAME target they use
   - Use the **same tunnel ID** for `vendor`

## Important Notes

- ✅ **Proxy must be ON** (orange cloud) - This routes through Cloudflare
- ✅ **Use CNAME, not A record** - CNAME points to tunnel
- ✅ **Wait 5-10 minutes** - DNS needs time to propagate

## Troubleshooting

### Still "Non-existent domain" after 10 minutes?

1. **Check CNAME was created:**
   - DNS → Records
   - Should see `vendor` CNAME record

2. **Check proxy is ON:**
   - CNAME should show orange cloud (proxied)
   - Not grey cloud (DNS only)

3. **Try different DNS server:**
   ```cmd
   nslookup vendor.berkeleyuae.com 8.8.8.8
   ```
   (Uses Google DNS instead of local DNS)

### Can't find tunnel ID?

- Check tunnel details page
- Look at other working subdomains' DNS records
- The tunnel ID is the same for all routes on the same tunnel

---

**Create the CNAME record and DNS will resolve correctly!**



