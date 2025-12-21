@echo off
echo ========================================
echo Vendor Form Setup Verification
echo ========================================
echo.

echo 1. Checking Docker containers...
echo.
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr /i "vendor-form cloudflared"
echo.

echo 2. Testing localhost:9000...
curl -s http://localhost:9000/api/health
if %errorlevel% equ 0 (
    echo.
    echo [OK] localhost:9000 is accessible
) else (
    echo [FAIL] localhost:9000 is NOT accessible
)
echo.

echo 3. Testing public domain...
curl -s https://vendor.berkeleyuae.com/api/health
if %errorlevel% equ 0 (
    echo.
    echo [OK] vendor.berkeleyuae.com is accessible
) else (
    echo [FAIL] vendor.berkeleyuae.com is NOT accessible
)
echo.

echo ========================================
echo Verification Complete
echo ========================================
echo.
echo Next steps:
echo   - If services aren't running: docker-compose -f docker-compose-cloudflare.yml up -d
echo   - Check logs: docker logs vendor-form-backend
echo   - Check logs: docker logs vendor-form-nginx
echo.
pause


