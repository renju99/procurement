# Fix DNS Resolution Issue

## Problem
`curl: (6) Could not resolve host: vendor.berkeleyuae.com`

This means your local machine can't resolve the DNS for `vendor.berkeleyuae.com`.

## Quick Checks

### 1. Verify DNS Still Resolves

Run this to check if DNS is working:

```powershell
nslookup vendor.berkeleyuae.com
```

**Expected output:**
```
Name: 35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com
Address: [some IP]
Aliases: vendor.berkeleyuae.com
```

**If it fails:**
- DNS record might have been removed
- DNS propagation issue
- Network/DNS server issue

### 2. Try Different DNS Servers

If nslookup fails, try using Google's DNS:

```powershell
nslookup vendor.berkeleyuae.com 8.8.8.8
```

Or Cloudflare's DNS:
```powershell
nslookup vendor.berkeleyuae.com 1.1.1.1
```

### 3. Check Cloudflare Dashboard

1. Go to: https://one.dash.cloudflare.com
2. Navigate to: **Zero Trust** → **Networks** → **Tunnels**
3. Find tunnel: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
4. Check **Public Hostname** tab
5. Verify `vendor.berkeleyuae.com` is listed

### 4. Verify DNS Record

**If berkeleyuae.com is on Cloudflare:**
1. Go to Cloudflare Dashboard
2. Select domain: `berkeleyuae.com`
3. Go to **DNS** → **Records**
4. Look for CNAME: `vendor` → `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
5. Should be **Proxied** (orange cloud)

**If berkeleyuae.com is NOT on Cloudflare:**
1. Go to your domain registrar (where you bought berkeleyuae.com)
2. Find DNS management
3. Look for CNAME record: `vendor` → `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`

## Solutions

### Solution 1: DNS Cache Issue

Clear DNS cache on Windows:

```powershell
# Run as Administrator
ipconfig /flushdns
```

Then try again:
```powershell
curl https://vendor.berkeleyuae.com/api/health
```

### Solution 2: DNS Record Missing

If the DNS record is missing, you need to add it:

**Option A: If berkeleyuae.com is on Cloudflare**
1. Cloudflare Dashboard → `berkeleyuae.com` → DNS → Records
2. Add CNAME:
   - **Name**: `vendor`
   - **Target**: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
   - **Proxy**: Proxied (orange cloud)
   - **TTL**: Auto

**Option B: If berkeleyuae.com is NOT on Cloudflare**
1. Go to your domain registrar
2. Add CNAME record:
   - **Host/Name**: `vendor`
   - **Value/Target**: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
   - **TTL**: 3600

### Solution 3: Use Alternative Domain

If `berkeleyuae.com` is not on Cloudflare and you can't add DNS records, use `proptechme.com` instead:

1. **Add route in Cloudflare:**
   - Zero Trust → Networks → Tunnels
   - Find tunnel: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
   - Add Public Hostname: `vendor.proptechme.com` → `http://localhost:9000`

2. **Add DNS in Cloudflare:**
   - Cloudflare Dashboard → `proptechme.com` → DNS → Records
   - Add CNAME: `vendor` → `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
   - Proxy: Proxied

3. **Update nginx config:**
   - Change `server_name` in `nginx-docker.conf` to include `vendor.proptechme.com`

## Test After Fix

```powershell
# 1. Verify DNS resolves
nslookup vendor.berkeleyuae.com

# 2. Test with curl
curl https://vendor.berkeleyuae.com/api/health

# 3. Or test in browser
# https://vendor.berkeleyuae.com/api/health
```

## Common Issues

### Issue: DNS resolves but curl fails
- **Cause**: SSL/TLS issue or service not running
- **Fix**: Check if services are running: `docker ps`

### Issue: DNS doesn't resolve at all
- **Cause**: DNS record missing or incorrect
- **Fix**: Add/verify DNS record (see Solution 2)

### Issue: Works on some networks but not others
- **Cause**: DNS propagation or local DNS cache
- **Fix**: Wait 5-10 minutes, flush DNS cache

## Next Steps

1. **First**: Run `nslookup vendor.berkeleyuae.com` to see current status
2. **If it fails**: Check Cloudflare dashboard for DNS record
3. **If record missing**: Add it (Solution 2)
4. **If record exists**: Try flushing DNS cache (Solution 1)
5. **If still fails**: Consider using `vendor.proptechme.com` (Solution 3)


