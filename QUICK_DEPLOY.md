# Quick Deploy to supplier.proptechme.com

## Fast Setup (5 minutes)

### 1. DNS Setup (Do this first!)
In your domain provider (GoDaddy, Namecheap, etc.):
- Add A record: `supplier` → `[Your Server IP]`
- Wait 5-10 minutes for DNS to propagate

### 2. Deploy to Server

```bash
# On your server
cd standalone-form

# Start with Nginx
docker-compose -f docker-compose-nginx.yml up -d

# Check status
docker ps
```

### 3. Test Access

Visit: `http://supplier.proptechme.com`

### 4. Set Up SSL (Optional but Recommended)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d supplier.proptechme.com
```

Then visit: `https://supplier.proptechme.com`

## File Structure

```
standalone-form/
├── docker-compose.yml          # Original (localhost only)
├── docker-compose-nginx.yml    # With Nginx reverse proxy
├── nginx.conf                  # Nginx configuration
└── ...
```

## What Gets Exposed

- **Public:** Port 80 (HTTP) and 443 (HTTPS)
- **Private:** Backend on localhost:3001 (not exposed publicly)
- **Domain:** supplier.proptechme.com → Your Server

## Verify It Works

```bash
# Test DNS
nslookup supplier.proptechme.com

# Test HTTP
curl http://supplier.proptechme.com

# Test API
curl http://supplier.proptechme.com/api/health
```

Done! 🎉
