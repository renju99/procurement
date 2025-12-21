# Exact Steps to Create CNAME Record

## Your Information

- **Tunnel ID**: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
- **CNAME Target**: `35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com`
- **Record Name**: `vendor`

## Exact Steps

1. **Click "Add record" button** (blue button, top right)

2. **Fill in exactly:**
   ```
   Type: CNAME
   Name: vendor
   Target: 35facd18-8eec-4678-aaf6-e8c5e11785e9.cfargotunnel.com
   Proxy: [Enable - Orange Cloud] ✅
   TTL: Auto
   ```

3. **Click "Save"**

4. **Verify it appears in the table** (should look like your other CNAME records)

5. **Wait 5-10 minutes**

6. **Test:**
   ```cmd
   nslookup vendor.berkeleyuae.com
   ```

7. **Visit:** `https://vendor.berkeleyuae.com`

---

**That's it! The CNAME record will route vendor.berkeleyuae.com through Cloudflare Tunnel to your port 9000 service.**



