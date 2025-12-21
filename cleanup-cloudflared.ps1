# Cleanup script to remove old vendor-form cloudflared containers

Write-Host "Stopping and removing vendor-form-cloudflared container..." -ForegroundColor Yellow

# Stop and remove vendor-form-cloudflared if it exists
docker stop vendor-form-cloudflared 2>$null
docker rm vendor-form-cloudflared 2>$null

Write-Host "Checking for any other vendor-form cloudflared containers..." -ForegroundColor Yellow

# List all containers with cloudflared in the name
docker ps -a | Select-String "cloudflared"

Write-Host "`nCleanup complete!" -ForegroundColor Green
Write-Host "You can now start services with: docker-compose -f docker-compose-cloudflare.yml up -d" -ForegroundColor Cyan


