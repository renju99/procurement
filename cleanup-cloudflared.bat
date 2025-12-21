@echo off
echo Stopping and removing vendor-form-cloudflared container...

docker stop vendor-form-cloudflared 2>nul
docker rm vendor-form-cloudflared 2>nul

echo.
echo Checking for any other vendor-form cloudflared containers...
docker ps -a | findstr cloudflared

echo.
echo Cleanup complete!
echo You can now start services with: docker-compose -f docker-compose-cloudflare.yml up -d
pause


