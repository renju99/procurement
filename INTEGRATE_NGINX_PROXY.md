# Integrating with Existing nginx-proxy

Since you already have an `nginx-proxy` container running, here are options to integrate:

## Option 1: Use nginx-proxy Auto-Configuration (Recommended)

If your nginx-proxy is `jwilder/nginx-proxy`, it can auto-detect containers:

### Update docker-compose.yml:

```yaml
form-backend:
  environment:
    - VIRTUAL_HOST=supplier.proptechme.com
    - VIRTUAL_PORT=3000
```

### Ensure nginx-proxy can access the network:

```yaml
networks:
  default:
    external: true
    name: nginx-proxy_default  # or your nginx-proxy network name
```

### Restart:

```bash
docker-compose up -d
```

## Option 2: Configure Existing nginx-proxy Manually

1. **Find your nginx-proxy configuration:**
   ```bash
   docker inspect nginx-proxy | grep -i mount
   ```

2. **Add configuration file** in nginx-proxy's conf.d directory:
   ```nginx
   upstream vendor_form_backend {
       server vendor-form-backend:3000;
   }
   
   server {
       listen 80;
       server_name supplier.proptechme.com;
       
       client_max_body_size 60M;
       
       location / {
           proxy_pass http://vendor_form_backend;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           
           proxy_connect_timeout 600;
           proxy_send_timeout 600;
           proxy_read_timeout 600;
       }
   }
   ```

3. **Reload nginx-proxy:**
   ```bash
   docker exec nginx-proxy nginx -s reload
   ```

## Option 3: Connect to nginx-proxy Network

```yaml
services:
  form-backend:
    networks:
      - nginx-proxy_network

networks:
  nginx-proxy_network:
    external: true
    name: nginx-proxy_default  # Check your actual network name
```

Find network name:
```bash
docker network ls | grep nginx
```

## DNS Setup

Regardless of option, ensure DNS points to your server:
```
A Record: supplier.proptechme.com → YOUR_SERVER_IP
```

## Test

After configuration:
```bash
curl http://supplier.proptechme.com/api/health
```

## Current Status

- ✅ Backend running on port 3000 (internal)
- ✅ Local access: http://localhost:3001
- ⏳ Need to configure nginx-proxy for domain access

