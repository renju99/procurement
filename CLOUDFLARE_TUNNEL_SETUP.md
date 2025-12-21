# Cloudflare Tunnel Setup (No Port Forwarding Required!)

This setup uses **Cloudflare Tunnel** to expose your vendor form without needing router port forwarding rules.

## ✅ Advantages

- ✅ **No port forwarding needed** - Works behind any firewall
- ✅ **Free SSL/HTTPS** - Automatic HTTPS via Cloudflare
- ✅ **DDoS protection** - Built into Cloudflare
- ✅ **No router access required** - Everything configured in Docker

## Prerequisites

1. **Cloudflare account** (free)
2. **Domain `berkeleyuae.com` added to Cloudflare** with DNS managed by Cloudflare
3. **Cloudflare Tunnel created** (we'll do this)

## Step 1: Install Cloudflare CLI (if not already installed)

**Windows:**
```powershell
# Download from: https://github.com/cloudflare/cloudflared/releases
# Or use Chocolatey:
choco install cloudflared
```

**Linux:**
```bash
# Download and install
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
```

## Step 2: Login to Cloudflare

```powershell
cloudflared tunnel login
```

This will:
1. Open your browser
2. Select your Cloudflare account
3. Authorize the tunnel
4. Save credentials automatically

## Step 3: Create a Tunnel

```powershell
cloudflared tunnel create vendor-form-tunnel
```

This will create a tunnel and give you a UUID. **Save this UUID** - you'll need it.

## Step 4: Create DNS Route

```powershell
cloudflared tunnel route dns vendor-form-tunnel vendor.berkeleyuae.com
```

This creates a CNAME record in Cloudflare DNS pointing `vendor.berkeleyuae.com` to your tunnel.

## Step 5: Get Tunnel Credentials

The credentials file should be at:
```
C:\Users\ranji\.cloudflared\[TUNNEL-UUID].json
```

**Copy this file** to your project directory and rename it:
```powershell
copy "C:\Users\ranji\.cloudflared\[TUNNEL-UUID].json" "cloudflared-credentials.json"
```

Replace `[TUNNEL-UUID]` with your actual tunnel UUID.

## Step 6: Update Configuration

The `cloudflared-config.yml` file is already created. Make sure it references your tunnel name:

```yaml
tunnel: vendor-form-tunnel  # Should match the tunnel you created
credentials-file: /etc/cloudflared/credentials.json
```

## Step 7: Start Services

```powershell
docker-compose -f docker-compose-cloudflare.yml up -d
```

## Step 8: Verify

1. **Check containers are running:**
   ```powershell
   docker ps
   ```

2. **Check Cloudflare Tunnel logs:**
   ```powershell
   docker logs vendor-form-cloudflared
   ```

3. **Access the form:**
   - Open: **https://vendor.berkeleyuae.com**
   - Should work without any port numbers!

## Alternative: Quick Setup with Cloudflare Dashboard

If you prefer using the Cloudflare dashboard:

1. **Go to Cloudflare Dashboard** → Your domain → **Zero Trust** → **Networks** → **Tunnels**

2. **Create a tunnel:**
   - Click "Create a tunnel"
   - Name: `vendor-form-tunnel`
   - Choose "Cloudflared" connector
   - Save the token

3. **Configure the tunnel:**
   - Add a public hostname:
     - **Subdomain**: `vendor`
     - **Domain**: `berkeleyuae.com`
     - **Service**: `http://localhost:8080` (or your nginx port)

4. **Run cloudflared with the token:**
   ```powershell
   cloudflared tunnel run --token YOUR_TOKEN
   ```

## Troubleshooting

### Tunnel not connecting?
```powershell
# Check tunnel logs
docker logs vendor-form-cloudflared

# Test tunnel manually
cloudflared tunnel --config cloudflared-config.yml run
```

### DNS not resolving?
- Check Cloudflare dashboard → DNS → Records
- Should see a CNAME: `vendor` → `[TUNNEL-UUID].cfargotunnel.com`
- Make sure DNS is "Proxied" (orange cloud) not "DNS only" (grey cloud)

### Can't access the form?
```powershell
# Check nginx is running
docker logs vendor-form-nginx

# Check backend is running
docker logs vendor-form-backend

# Test locally
Invoke-WebRequest -Uri http://localhost:8080/api/health
```

## Current Setup

- **Backend**: Running on `localhost:3001` (internal)
- **Nginx**: Running on port `80` (internal, no external mapping)
- **Cloudflare Tunnel**: Exposes nginx to the internet via `vendor.berkeleyuae.com`
- **Access URL**: `https://vendor.berkeleyuae.com` (no port needed!)

## Benefits of This Approach

1. ✅ **No router configuration** - Works from anywhere
2. ✅ **Automatic HTTPS** - Cloudflare provides SSL
3. ✅ **Better security** - Service not directly exposed
4. ✅ **Free** - Cloudflare Tunnel is free
5. ✅ **Professional URL** - No port numbers in URL

---

**After setup, your form will be accessible at: `https://vendor.berkeleyuae.com`**

No port forwarding, no port numbers, just a clean URL! 🎉



