# Update Cloudflare Route to Port 9000

## ✅ Configuration Updated

I've changed the Docker configuration to use **port 9000** instead of 8080.

## ⚠️ IMPORTANT: Update Cloudflare Route

You need to update your Cloudflare Tunnel route to point to the new port:

### Step 1: Go to Cloudflare Dashboard

1. Go to: https://dash.cloudflare.com
2. Click **Zero Trust** → **Networks** → **Tunnels**
3. Click on your tunnel
4. Find the route for `vendor.berkeleyuae.com`
5. Click **Edit**

### Step 2: Update Service URL

**Change from:**
- `http://localhost:8080` ❌

**Change to:**
- `http://localhost:9000` ✅

### Step 3: Save

1. Click **Save**
2. Wait 1-2 minutes for changes to propagate

## After Updating Cloudflare

1. **Start services:**
   ```powershell
   docker-compose -f docker-compose-nginx.yml up -d
   ```

2. **Test locally:**
   ```powershell
   curl http://localhost:9000/api/health
   ```

3. **Clear browser cache** and visit:
   - `https://vendor.berkeleyuae.com`

## Why Port 9000?

- Port 80 - Used by 3CX
- Port 443 - Used by 3CX  
- Port 8080 - Might be in use
- Port 9000 - Available ✅

## Alternative Ports

If port 9000 is also in use, you can change to:

- **Port 5000**: Edit `docker-compose-nginx.yml` → Change `"9000:80"` to `"5000:80"`
- **Port 3000**: Edit `docker-compose-nginx.yml` → Change `"9000:80"` to `"3000:80"`
- **Port 8888**: Edit `docker-compose-nginx.yml` → Change `"9000:80"` to `"8888:80"`

Then update Cloudflare route to match the new port.

---

**Remember: Always update both Docker config AND Cloudflare route to use the same port!**



