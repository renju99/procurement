# Fix: "Failed to fetch" Error

## Problem
When opening the HTML file directly (double-clicking), browsers block CORS requests due to the `file://` protocol.

## Solution: Serve the Form via HTTP Server

### Option 1: Using Python (Easiest)

1. **Open PowerShell in the `standalone-form` folder**
2. **Run:**
   ```powershell
   python -m http.server 8000
   ```
3. **Open in browser:**
   ```
   http://localhost:8000/vendor-registration-form.html
   ```

### Option 2: Using the Provided Script

**Windows:**
```powershell
.\serve-form.ps1
```

Or double-click: `serve-form.bat`

### Option 3: Using Node.js

```bash
npx http-server -p 8000
```

Then visit: `http://localhost:8000/vendor-registration-form.html`

## Verify Backend is Running

```powershell
# Check container status
docker ps --filter name=vendor-form-backend

# Test API
Invoke-WebRequest -Uri http://localhost:3001/api/health
```

## What I Fixed

1. ✅ **Updated CORS configuration** - Now handles `file://` protocol
2. ✅ **Improved error messages** - Better feedback when connection fails
3. ✅ **Rebuilt Docker container** - Changes are now active

## Quick Test

1. **Start HTTP server:**
   ```powershell
   cd standalone-form
   python -m http.server 8000
   ```

2. **Open browser:**
   ```
   http://localhost:8000/vendor-registration-form.html
   ```

3. **Fill and submit form** - Should work now!

## Why This Happens

- Browsers block `file://` → `http://` requests for security
- Serving via HTTP server makes it `http://` → `http://` (allowed)
- This is standard web security (CORS policy)

## Alternative: Use Browser Extension

If you must use `file://`, you can disable CORS in Chrome:
```
chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security
```
⚠️ **Not recommended for production!**

