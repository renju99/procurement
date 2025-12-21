# Fix Certificate Errors - Clean Up Old Cloudflared Container

## Problem

You're seeing certificate errors because there's likely an old `vendor-form-cloudflared` container trying to start with the old configuration that requires credentials files.

## Solution: Clean Up Old Containers

### Step 1: Stop and Remove Old Cloudflared Container

Run one of these commands:

**PowerShell:**
```powershell
.\cleanup-cloudflared.ps1
```

**Or manually:**
```powershell
docker stop vendor-form-cloudflared
docker rm vendor-form-cloudflared
```

**Command Prompt:**
```cmd
cleanup-cloudflared.bat
```

**Or manually:**
```cmd
docker stop vendor-form-cloudflared
docker rm vendor-form-cloudflared
```

### Step 2: Verify No Cloudflared Containers Are Running

Check for any vendor-form cloudflared containers:
```powershell
docker ps -a | Select-String "vendor-form.*cloudflared"
```

If you see any, remove them:
```powershell
docker rm -f vendor-form-cloudflared
```

### Step 3: Start Services (Without Cloudflared)

Now start only the backend and nginx:
```powershell
docker-compose -f docker-compose-cloudflare.yml up -d
```

This will start:
- ✅ `vendor-form-backend` (on localhost:3001)
- ✅ `vendor-form-nginx` (on localhost:9000)
- ❌ NO cloudflared (using guardpro's tunnel instead)

### Step 4: Verify Services Are Running

```powershell
docker ps | Select-String "vendor-form"
```

You should see:
- `vendor-form-backend`
- `vendor-form-nginx`

You should **NOT** see:
- `vendor-form-cloudflared` ❌

### Step 5: Add Route in Cloudflare Dashboard

Since we're using guardpro's tunnel, add the route there:

1. Go to **Cloudflare Dashboard** → **Zero Trust** → **Networks** → **Tunnels**
2. Find tunnel: `35facd18-8eec-4678-aaf6-e8c5e11785e9`
3. Click on tunnel → **Public Hostname** tab
4. Click **"Add a public hostname"**
5. Configure:
   - **Subdomain**: `vendor`
   - **Domain**: `berkeleyuae.com` or `proptechme.com`
   - **Service**: `http://localhost:9000`
   - **Path**: (leave empty)
6. Click **Save**

## Why This Works

- **Before**: Separate cloudflared container trying to use config file → certificate errors
- **After**: Using guardpro's existing tunnel (token-based) → no certificate needed
- **Nginx**: Exposed on `localhost:9000` so guardpro cloudflared can access it

## Troubleshooting

### Still seeing errors?

1. **Check if container is restarting:**
   ```powershell
   docker ps -a | Select-String "cloudflared"
   ```

2. **Check guardpro docker-compose:**
   - Make sure guardpro's cloudflared is running: `docker ps | Select-String "cloudflared-tunnel"`
   - It should be using the token, not a config file

3. **Remove all vendor-form cloudflared containers:**
   ```powershell
   docker rm -f $(docker ps -aq --filter "name=vendor-form-cloudflared")
   ```

4. **Check for restart policies:**
   - Old containers with `restart: unless-stopped` will keep restarting
   - Remove them completely: `docker rm -f <container-name>`

### Verify Setup

After cleanup, verify:
```powershell
# Should show backend and nginx only
docker ps | Select-String "vendor-form"

# Should show guardpro's cloudflared tunnel
docker ps | Select-String "cloudflared-tunnel"
```


