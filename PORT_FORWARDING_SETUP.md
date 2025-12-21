# Port Forwarding Setup for vendor.berkeleyuae.com

## Current Port Status

Based on your network configuration, these ports are **already in use**:
- **Port 443** - 3CX (HTTPS)
- **Port 80** - Likely in use (standard HTTP)
- **Port 8081** - In use
- **Port 8082** - biotime
- **Port 8089** - CMS SRV
- **Port 9000-10999** - 3CX UDP range
- **Port 5060-5061** - 3CX
- And others...

## Recommended Ports for Vendor Form

I've configured the vendor registration form to use:
- **Port 8080** - HTTP (not in your current list)
- **Port 8443** - HTTPS (not in your current list)

## ⚠️ IMPORTANT: Add Port Forwarding Rules

You need to add **two new port forwarding rules** in your router/firewall:

### Rule 1: HTTP (Port 8080)
```
Name: Vendor Form HTTP
Protocol: TCP
Source: Any (or specific IP/range)
Forward IP: [Your Server's Internal IP - where Docker is running]
Forward Port: 8080
WAN: 83.110.23.106 (or your external IP)
```

### Rule 2: HTTPS (Port 8443)
```
Name: Vendor Form HTTPS
Protocol: TCP
Source: Any (or specific IP/range)
Forward IP: [Your Server's Internal IP - where Docker is running]
Forward Port: 8443
WAN: 83.110.23.106 (or your external IP)
```

## Alternative Port Options

If ports 8080 or 8443 are also in use, here are other available options:

### Option 1: Ports 5000 and 5443
```yaml
ports:
  - "5000:80"    # HTTP
  - "5443:443"   # HTTPS
```

### Option 2: Ports 3000 and 3443
```yaml
ports:
  - "3000:80"    # HTTP
  - "3443:443"   # HTTPS
```

### Option 3: Ports 8888 and 8889
```yaml
ports:
  - "8888:80"    # HTTP
  - "8889:443"   # HTTPS
```

## Steps to Complete Setup

### 1. Choose Your Ports
Decide which ports you want to use (8080/8443 recommended, or choose from alternatives above).

### 2. Update docker-compose-nginx.yml (if needed)
If you want different ports, edit the file:
```yaml
nginx:
  ports:
    - "YOUR_HTTP_PORT:80"
    - "YOUR_HTTPS_PORT:443"
```

### 3. Add Port Forwarding Rules
In your router/firewall admin panel:
- Add the two port forwarding rules as shown above
- Make sure the Forward IP points to your Docker server's internal IP

### 4. Restart Docker Services
```powershell
docker-compose -f docker-compose-nginx.yml down
docker-compose -f docker-compose-nginx.yml up -d
```

### 5. Test Access
- **HTTP**: `http://vendor.berkeleyuae.com:8080` (or your chosen port)
- **API**: `http://vendor.berkeleyuae.com:8080/api/health`

## Finding Your Server's Internal IP

To find the internal IP of your Docker server:

**Windows:**
```powershell
ipconfig
```
Look for IPv4 Address (usually 192.168.x.x or 172.16.x.x)

**Linux:**
```bash
ip addr show
# or
hostname -I
```

## Verification Checklist

- [ ] Port forwarding rules added in router/firewall
- [ ] Docker services restarted
- [ ] Can access `http://vendor.berkeleyuae.com:8080` from internet
- [ ] Form loads correctly
- [ ] Form submission works

## Current Configuration

The `docker-compose-nginx.yml` is currently set to:
- **Port 8080** for HTTP
- **Port 8443** for HTTPS

These ports should work, but you **must add the port forwarding rules** in your router for external access to work.

---

**Next Step**: Add the port forwarding rules, then restart Docker services and test!



