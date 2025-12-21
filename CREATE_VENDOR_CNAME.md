# Create CNAME Record for vendor.berkeleyuae.com

## Your Tunnel ID
`35facd18-8eec-4678-aaf6-e8c5e11785e9`

## Step-by-Step Instructions

### Step 1: Go to DNS Records

1. **Cloudflare Dashboard** → Your domain (`berkeleyuae.com` or `proptechme.com`)
2. Click **DNS** → **Records**

### Step 2: Add CNAME Record

1. Click the blue **"Add record"** button (top right)

2. Fill in the form:
   - **Type**: Select `CNAME` from dropdown
   - **Name**: `vendor`
   - **Target**: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
   - **Proxy status**: Click to enable **Proxied** (orange cloud) ✅ **CRITICAL!**
   - **TTL**: Select `Auto`
   
3. Click **Save**

### Step 3: Verify the Record

After saving, you should see a new row in the table:
- **Type**: CNAME
- **Name**: vendor
- **Content**: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
- **Proxy status**: **Proxied** (orange cloud with arrow)
- **TTL**: Auto

It should look exactly like your other CNAME records (forms, meal, n8n, sentry).

## Step 4: Wait and Test

1. **Wait 5-10 minutes** for DNS propagation

2. **Test DNS:**
   ```cmd
   nslookup vendor.berkeleyuae.com
   ```
   
   **Should now show:**
   - Cloudflare IP addresses (like 104.x.x.x or 172.x.x.x)
   - NOT "Non-existent domain"

3. **Test Website:**
   - Clear browser cache (Ctrl+Shift+Delete)
   - Or use incognito mode (Ctrl+Shift+N)
   - Visit: `https://vendor.berkeleyuae.com`
   - Should now show the vendor registration form!

## Important Notes

✅ **Proxy MUST be ON** (orange cloud) - This is critical!
- If proxy is OFF (grey cloud), it won't work correctly
- Make sure it shows "Proxied" like your other records

✅ **Use exact tunnel ID:**
- `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
- Same format as your other CNAME records

✅ **Wait for DNS propagation:**
- Can take 5-10 minutes
- Sometimes up to 30 minutes

## Troubleshooting

### Still "Non-existent domain" after 10 minutes?

1. **Check record was created:**
   - DNS → Records
   - Should see `vendor` CNAME record

2. **Check proxy is ON:**
   - Should show orange cloud (Proxied)
   - Not grey cloud (DNS only)

3. **Try different DNS server:**
   ```cmd
   nslookup vendor.berkeleyuae.com 8.8.8.8
   ```
   (Uses Google DNS)

### Still seeing 3CX?

1. **Verify services are running:**
   ```cmd
   docker ps --filter "name=vendor-form"
   curl http://localhost:9000/api/health
   ```

2. **Clear browser cache completely**

3. **Wait a bit longer** (up to 30 minutes for full propagation)

---

**Create the CNAME record with proxy ON, wait 5-10 minutes, and vendor.berkeleyuae.com should work!**



