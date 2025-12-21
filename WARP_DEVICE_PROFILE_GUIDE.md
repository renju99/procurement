# WARP Device Profile Configuration Guide

## Understanding the Message

The message about WARP device profile is **for client-side WARP devices** (end-user devices), not for Cloudflare Tunnel (cloudflared).

### Two Different Things:
- **Cloudflare Tunnel (cloudflared)**: Server-side, what we're using ✅
- **WARP**: Client-side, for end-user devices (optional)

## For Public Hostname Routes

If `vendor.berkeleyuae.com` is a **public hostname** (accessible from the internet), you typically **don't need WARP** configuration.

### Option 1: Ignore WARP Message (Recommended for Public Routes)

If this is a public hostname route:
1. **Continue without WARP configuration**
2. The route should work via Cloudflare Tunnel
3. Test if it works: `curl https://vendor.berkeleyuae.com/api/health`

### Option 2: Configure WARP (If Required)

If the route isn't working and you need to configure WARP:

#### Step 1: Go to WARP Device Profile Settings

1. In Cloudflare Zero Trust dashboard
2. Go to: **Networks** → **Device Profiles**
3. Find your device profile (or create one)

#### Step 2: Configure Split Tunnels

1. Click on your device profile
2. Go to **Split Tunnels** section
3. **Ensure** `100.64.0.0/10` is **NOT** in the Exclude list
4. **Ensure** your private origin IPs are **NOT** excluded

#### Step 3: Check Local Domain Fallback

1. In device profile settings
2. Go to **Local Domain Fallback**
3. **Ensure** `vendor.berkeleyuae.com` is **NOT** in the fallback list

## Quick Check: Is This a Public or Private Route?

### Public Route (What We Want):
- ✅ Accessible from the internet
- ✅ Uses Cloudflare Tunnel (cloudflared)
- ✅ No WARP required for basic functionality
- ✅ Example: `vendor.berkeleyuae.com` → `http://localhost:9000`

### Private Route:
- ❌ Only accessible via WARP
- ❌ Requires WARP client on user devices
- ❌ Not what we're setting up

## Recommended Action

### For Public Hostname Route:

1. **Skip WARP configuration** (if route type is public)
2. **Complete the route creation**
3. **Test if it works:**
   ```powershell
   curl https://vendor.berkeleyuae.com/api/health
   ```

### If Route Doesn't Work:

1. **Check if you selected "Private" instead of "Public"**
   - Go back and verify route type
   - Should be **Public hostname**

2. **Or configure WARP** (if really needed):
   - Follow Option 2 steps above

## Alternative: Use Public Hostname Tab

If the "Hostname routes" interface is causing issues, try the traditional method:

1. Go to tunnel overview
2. Click **"Public Hostname"** tab (not "Hostname routes")
3. Click **"Add a public hostname"**
4. Configure:
   - **Subdomain**: `vendor`
   - **Domain**: `berkeleyuae.com`
   - **Service**: `http://localhost:9000`
   - **Path**: (leave empty)

This method typically doesn't require WARP configuration.

## Current Status

You're creating a route for `vendor.berkeleyuae.com` → `http://localhost:9000`

**Questions to answer:**
1. Is this route marked as "Public" or "Private"?
2. Did you see an option to select route type?

**Recommended:**
- If it's **Public**: Continue without WARP, test if it works
- If it's **Private**: Either change to Public, or configure WARP

## Next Steps

1. **Check the route type** (Public vs Private)
2. **If Public**: Complete the route and test
3. **If Private**: Either switch to Public, or configure WARP settings
4. **Test**: `curl https://vendor.berkeleyuae.com/api/health`

## Testing After Setup

Once the route is created (with or without WARP):

```powershell
# 1. Test DNS
nslookup vendor.berkeleyuae.com

# 2. Test endpoint
curl https://vendor.berkeleyuae.com/api/health

# 3. Test in browser
# https://vendor.berkeleyuae.com
```

If it works, WARP configuration wasn't needed!


