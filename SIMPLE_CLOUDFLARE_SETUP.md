# Simple Cloudflare Tunnel Setup (Using Existing Tunnel)

Since you already have `cloudflared` running, we can either:
1. **Add a route to your existing tunnel** (easiest)
2. **Create a new tunnel** (if you prefer separate tunnels)

## Option 1: Add Route to Existing Tunnel (Recommended)

If you already have a Cloudflare Tunnel running, you can add a route for `vendor.berkeleyuae.com`:

### Via Cloudflare Dashboard:

1. **Go to Cloudflare Dashboard** → Your domain → **Zero Trust** → **Networks** → **Tunnels**

2. **Click on your existing tunnel** (the one that's currently running)

3. **Add a Public Hostname:**
   - Click "Configure" or "Add a public hostname"
   - **Subdomain**: `vendor`
   - **Domain**: `berkeleyuae.com`
   - **Service Type**: `HTTP`
   - **Service URL**: `http://localhost:8080` (or the port where nginx is running)
   - Click "Save hostname"

4. **That's it!** The tunnel will automatically route `vendor.berkeleyuae.com` to your local service.

### Via Command Line:

```powershell
# List your tunnels
cloudflared tunnel list

# Route DNS for vendor.berkeleyuae.com to your existing tunnel
cloudflared tunnel route dns [YOUR-TUNNEL-NAME] vendor.berkeleyuae.com
```

## Option 2: Use Cloudflare DNS Proxy (If Domain is on Cloudflare)

If `berkeleyuae.com` is already on Cloudflare and you just need to point the DNS:

1. **Go to Cloudflare Dashboard** → **DNS** → **Records**

2. **Add a CNAME record:**
   - **Type**: CNAME
   - **Name**: `vendor`
   - **Target**: `[YOUR-TUNNEL-UUID].cfargotunnel.com`
   - **Proxy status**: Proxied (orange cloud) ✅
   - **TTL**: Auto

3. **In your tunnel configuration**, add the route:
   - **Hostname**: `vendor.berkeleyuae.com`
   - **Service**: `http://localhost:8080`

## Quick Setup Steps

### 1. Make sure your services are running on localhost:8080

```powershell
# Start with the port 8080 configuration
docker-compose -f docker-compose-nginx.yml up -d

# Verify nginx is accessible locally
Invoke-WebRequest -Uri http://localhost:8080/api/health
```

### 2. Configure Cloudflare Tunnel

**If using existing tunnel:**
- Add route in Cloudflare dashboard as shown above

**If creating new tunnel:**
- Follow the steps in `CLOUDFLARE_TUNNEL_SETUP.md`

### 3. Test Access

After configuration:
- Wait 1-2 minutes for DNS propagation
- Access: **https://vendor.berkeleyuae.com**
- Should work without any port numbers!

## Which Port Should the Tunnel Point To?

The Cloudflare Tunnel should point to:
- **`http://localhost:8080`** - If using nginx on port 8080
- **`http://localhost:3001`** - If you want to bypass nginx (not recommended)

**Recommended**: Use `http://localhost:8080` (nginx) for better performance and features.

## Current Configuration Status

✅ **Docker services**: Configured to run on port 8080  
✅ **Nginx**: Ready to serve on port 8080  
⏳ **Cloudflare Tunnel**: Needs to be configured to route `vendor.berkeleyuae.com` → `localhost:8080`

## Next Steps

1. **Start Docker services:**
   ```powershell
   docker-compose -f docker-compose-nginx.yml up -d
   ```

2. **Configure Cloudflare Tunnel:**
   - Either add route to existing tunnel (easiest)
   - Or create new tunnel following `CLOUDFLARE_TUNNEL_SETUP.md`

3. **Test:**
   - Access `https://vendor.berkeleyuae.com`
   - Should see the vendor registration form!

---

**This approach requires NO router configuration and works immediately!** 🚀



