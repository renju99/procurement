# Running Form in Docker ✅

## Complete Docker Setup

The form is now fully containerized! Both the backend API and the HTML form are served from the same Docker container.

## Access Points

### Form (Frontend)
```
http://localhost:3001/
```
or
```
http://localhost:3001/vendor-registration-form.html
```

### API Endpoints
- **Health Check:** `http://localhost:3001/api/health`
- **Submit Form:** `http://localhost:3001/api/submit`

## Quick Start

1. **Start everything:**
   ```powershell
   cd standalone-form
   docker-compose up -d
   ```

2. **Open in browser:**
   ```
   http://localhost:3001
   ```

3. **That's it!** The form is ready to use.

## Benefits

✅ **No CORS issues** - Form and API served from same origin  
✅ **Single container** - Everything in one place  
✅ **Easy deployment** - Just deploy the Docker container  
✅ **No separate HTTP server needed** - Docker serves everything  

## Container Management

### View Logs
```powershell
docker logs vendor-form-backend
docker logs -f vendor-form-backend  # Follow logs
```

### Restart
```powershell
docker-compose restart
```

### Stop
```powershell
docker-compose down
```

### Rebuild (after code changes)
```powershell
docker-compose up -d --build
```

## Data Persistence

- **Uploads:** `standalone-form/uploads/` (mapped to container)
- **Submissions:** `standalone-form/data/submissions.json` (mapped to container)

Data persists even when container is stopped/restarted.

## Production Deployment

For production, just:
1. Deploy the Docker container to your server
2. Update the domain/port in docker-compose.yml
3. Set up reverse proxy (Nginx) if needed
4. Configure SSL/HTTPS

Everything runs in Docker - no separate servers needed! 🐳

