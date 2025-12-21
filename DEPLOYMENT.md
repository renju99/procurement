# Deployment Guide

This guide covers different deployment options for the vendor registration form.

## Table of Contents
1. [Docker Deployment](#docker-deployment)
2. [Docker Compose Deployment](#docker-compose-deployment)
3. [Manual Server Deployment](#manual-server-deployment)
4. [Cloud Platform Deployment](#cloud-platform-deployment)
5. [Frontend Deployment (GitHub Pages)](#frontend-deployment)

---

## Docker Deployment

### Prerequisites
- Docker installed on your system
- Docker Compose (optional, for easier management)

### Quick Start with Docker

1. **Build and run the container:**
   ```bash
   cd standalone-form
   docker build -t vendor-form-backend .
   docker run -d \
     --name vendor-form-backend \
     -p 3000:3000 \
     -v $(pwd)/uploads:/app/uploads \
     -v $(pwd)/data:/app/data \
     vendor-form-backend
   ```

2. **Check if it's running:**
   ```bash
   docker ps
   docker logs vendor-form-backend
   ```

3. **Test the API:**
   ```bash
   curl http://localhost:3000/api/health
   ```

### Using Docker Compose (Recommended)

1. **Start the service:**
   ```bash
   cd standalone-form
   docker-compose up -d
   ```

2. **View logs:**
   ```bash
   docker-compose logs -f
   ```

3. **Stop the service:**
   ```bash
   docker-compose down
   ```

4. **Restart the service:**
   ```bash
   docker-compose restart
   ```

### Docker Environment Variables

You can customize the deployment using environment variables:

```bash
docker run -d \
  --name vendor-form-backend \
  -p 3000:3000 \
  -e PORT=3000 \
  -e CORS_ORIGIN=https://yourdomain.com \
  -v $(pwd)/uploads:/app/uploads \
  -v $(pwd)/data:/app/data \
  vendor-form-backend
```

Or in `docker-compose.yml`:
```yaml
environment:
  - PORT=3000
  - CORS_ORIGIN=https://yourdomain.com
  - NODE_ENV=production
```

---

## Docker Compose Deployment

### Production Setup

1. **Create a production docker-compose file:**
   ```yaml
   # docker-compose.prod.yml
   version: '3.8'
   
   services:
     form-backend:
       build: .
       container_name: vendor-form-backend
       ports:
         - "3000:3000"
       environment:
         - NODE_ENV=production
         - PORT=3000
         - CORS_ORIGIN=https://yourdomain.com
       volumes:
         - ./uploads:/app/uploads
         - ./data:/app/data
       restart: always
       networks:
         - form-network
   
   networks:
     form-network:
       driver: bridge
   ```

2. **Deploy:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

### With Nginx Reverse Proxy

If you want to use a custom domain with SSL:

```yaml
# docker-compose.yml
version: '3.8'

services:
  form-backend:
    build: .
    container_name: vendor-form-backend
    environment:
      - NODE_ENV=production
      - PORT=3000
    volumes:
      - ./uploads:/app/uploads
      - ./data:/app/data
    restart: always
    networks:
      - form-network

  nginx:
    image: nginx:alpine
    container_name: form-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - form-backend
    networks:
      - form-network

networks:
  form-network:
    driver: bridge
```

---

## Manual Server Deployment

### On Linux/Ubuntu Server

1. **SSH into your server:**
   ```bash
   ssh user@your-server.com
   ```

2. **Install Node.js:**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

3. **Clone or upload your project:**
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo/standalone-form
   ```

4. **Install dependencies:**
   ```bash
   npm install --production
   ```

5. **Set up PM2 (Process Manager):**
   ```bash
   sudo npm install -g pm2
   pm2 start server.js --name vendor-form-backend
   pm2 save
   pm2 startup
   ```

6. **Set up Nginx reverse proxy:**
   ```bash
   sudo apt-get install nginx
   ```

   Create `/etc/nginx/sites-available/form-backend`:
   ```nginx
   server {
       listen 80;
       server_name api.yourdomain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   Enable the site:
   ```bash
   sudo ln -s /etc/nginx/sites-available/form-backend /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

---

## Cloud Platform Deployment

### Railway

1. **Install Railway CLI:**
   ```bash
   npm i -g @railway/cli
   railway login
   ```

2. **Deploy:**
   ```bash
   cd standalone-form
   railway init
   railway up
   ```

3. **Set environment variables in Railway dashboard:**
   - `PORT` (auto-set)
   - `CORS_ORIGIN` (your frontend domain)

### Render

1. **Create new Web Service**
2. **Connect GitHub repository**
3. **Settings:**
   - Build Command: `npm install`
   - Start Command: `node server.js`
   - Environment: `Node`
4. **Add Environment Variables:**
   - `NODE_ENV=production`
   - `CORS_ORIGIN=https://yourdomain.com`

### Heroku

1. **Install Heroku CLI**
2. **Create Procfile:**
   ```
   web: node server.js
   ```

3. **Deploy:**
   ```bash
   heroku create your-app-name
   git push heroku main
   heroku config:set CORS_ORIGIN=https://yourdomain.com
   ```

### DigitalOcean App Platform

1. **Create new App**
2. **Connect GitHub repository**
3. **Configure:**
   - Build Command: `npm install`
   - Run Command: `node server.js`
   - Environment Variables: Set `CORS_ORIGIN`

---

## Frontend Deployment

### GitHub Pages

1. **Update API URL in `vendor-registration-form.html`:**
   ```javascript
   const apiUrl = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
       ? 'http://localhost:3000/api/submit'
       : 'https://api.yourdomain.com/api/submit';  // Your backend URL
   ```

2. **Push to GitHub:**
   ```bash
   git add vendor-registration-form.html
   git commit -m "Update API URL"
   git push origin main
   ```

3. **Enable GitHub Pages:**
   - Go to repository Settings → Pages
   - Source: Deploy from branch
   - Branch: `main` / `/ (root)`
   - Save

4. **Your form will be live at:**
   `https://yourusername.github.io/your-repo/vendor-registration-form.html`

### Netlify / Vercel

1. **Connect your GitHub repository**
2. **Build settings:**
   - Build command: (leave empty, it's a static site)
   - Publish directory: `/` or root
3. **Add environment variable for API URL** (if using build-time replacement)

---

## Security Considerations

### 1. CORS Configuration

Update `server.js` to restrict CORS in production:

```javascript
app.use(cors({
    origin: process.env.CORS_ORIGIN || 'https://yourdomain.com',
    credentials: true
}));
```

### 2. Rate Limiting

Add rate limiting to prevent abuse:

```bash
npm install express-rate-limit
```

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/submit', limiter);
```

### 3. File Size Limits

Already configured in `server.js` (10MB per file). Adjust if needed.

### 4. HTTPS

Always use HTTPS in production. Use Let's Encrypt for free SSL certificates:

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com
```

---

## Monitoring & Maintenance

### View Logs

**Docker:**
```bash
docker logs vendor-form-backend
docker logs -f vendor-form-backend  # Follow logs
```

**PM2:**
```bash
pm2 logs vendor-form-backend
pm2 monit
```

### Backup Data

**Backup submissions and uploads:**
```bash
# Docker
docker exec vendor-form-backend tar -czf /tmp/backup.tar.gz /app/data /app/uploads
docker cp vendor-form-backend:/tmp/backup.tar.gz ./backup-$(date +%Y%m%d).tar.gz

# Manual
tar -czf backup-$(date +%Y%m%d).tar.gz data/ uploads/
```

### Health Check

The server includes a health check endpoint:
```bash
curl http://localhost:3000/api/health
```

---

## Troubleshooting

### Container won't start
- Check logs: `docker logs vendor-form-backend`
- Verify port 3000 is not in use: `netstat -tulpn | grep 3000`
- Check Docker resources: `docker stats`

### Files not uploading
- Verify volume mounts: `docker inspect vendor-form-backend`
- Check permissions: `ls -la uploads/`
- Check disk space: `df -h`

### CORS errors
- Verify `CORS_ORIGIN` environment variable
- Check browser console for exact error
- Ensure frontend URL matches CORS_ORIGIN

---

## Next Steps

1. ✅ **Deploy backend** using Docker or your preferred method
2. ✅ **Update API URL** in the form HTML file
3. ✅ **Deploy frontend** to GitHub Pages or your hosting
4. ✅ **Test the complete flow** end-to-end
5. ✅ **Set up monitoring** and backups
6. ✅ **Configure SSL/HTTPS** for production

Your form is now ready for production deployment! 🚀

