# Manual Start Instructions

Since the batch file is closing, here are manual commands you can run:

## Option 1: Run in Command Prompt (Recommended)

1. **Open Command Prompt** (not PowerShell)
   - Press `Win + R`
   - Type: `cmd`
   - Press Enter

2. **Navigate to the folder:**
   ```
   cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"
   ```

3. **Run these commands one by one:**
   ```
   docker-compose -f docker-compose-nginx.yml down
   docker-compose -f docker-compose-nginx.yml up -d
   timeout /t 15
   docker ps --filter "name=vendor-form"
   curl http://localhost:9000/api/health
   pause
   ```

## Option 2: Use PowerShell

1. **Open PowerShell**
2. **Navigate:**
   ```powershell
   cd "C:\Users\ranji\OneDrive\Desktop\Berkeley's Vendor Registration Form"
   ```

3. **Run:**
   ```powershell
   docker-compose -f docker-compose-nginx.yml down
   docker-compose -f docker-compose-nginx.yml up -d
   Start-Sleep -Seconds 15
   docker ps --filter "name=vendor-form"
   Invoke-WebRequest -Uri http://localhost:9000/api/health
   Read-Host "Press Enter to continue"
   ```

## Option 3: Try the New Batch File

I've created `run-vendor-form.bat` which should be more robust.

**Double-click:** `run-vendor-form.bat`

If it still closes, run it from Command Prompt:
```
cmd /c run-vendor-form.bat
```

## Quick Commands Summary

```cmd
REM Stop and start
docker-compose -f docker-compose-nginx.yml down
docker-compose -f docker-compose-nginx.yml up -d

REM Wait
timeout /t 15

REM Check status
docker ps --filter "name=vendor-form"

REM Test
curl http://localhost:9000/api/health
```

## After Starting Services

1. **Update Cloudflare Route:**
   - Go to Cloudflare Dashboard
   - Zero Trust → Networks → Tunnels
   - Edit `vendor.berkeleyuae.com` route
   - Change to: `http://localhost:9000`
   - Save

2. **Wait 1-2 minutes**

3. **Clear browser cache**

4. **Visit:** `https://vendor.berkeleyuae.com`

---

**The batch file closing is likely due to an error. Running commands manually will show you what's wrong.**



