@echo off
title Vendor Form Services
color 0A
echo.
echo ========================================
echo   Vendor Form - Start Services
echo ========================================
echo.

cd /d "%~dp0"

echo [Step 1/3] Stopping existing containers...
docker-compose -f docker-compose-nginx.yml down 2>nul
if %errorlevel% neq 0 (
    echo   Note: Some containers may not have been running
)

echo.
echo [Step 2/3] Starting services on port 9000...
docker-compose -f docker-compose-nginx.yml up -d
if %errorlevel% neq 0 (
    echo.
    echo   ERROR: Failed to start services!
    echo   Check Docker is running and try again.
    echo.
    pause
    exit /b 1
)

echo.
echo [Step 3/3] Waiting for services to initialize...
timeout /t 10 /nobreak >nul

echo.
echo ========================================
echo   Service Status
echo ========================================
echo.
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ========================================
echo   Testing Port 9000
echo ========================================
echo.
curl -s http://localhost:9000/api/health 2>nul
if %errorlevel% equ 0 (
    echo.
    echo.
    echo ========================================
    echo   SUCCESS!
    echo ========================================
    echo.
    echo   Services are running on port 9000!
    echo.
) else (
    echo   Testing connection...
    timeout /t 2 /nobreak >nul
    curl -s http://localhost:9000/api/health 2>nul
    if %errorlevel% equ 0 (
        echo.
        echo   Connection successful!
    ) else (
        echo.
        echo   WARNING: Port 9000 not responding yet.
        echo   Services may still be starting...
        echo.
        echo   Check logs with:
        echo     docker logs vendor-form-nginx
        echo     docker logs vendor-form-backend
    )
)

echo.
echo ========================================
echo   NEXT STEPS
echo ========================================
echo.
echo   1. Update Cloudflare Route:
echo      - Go to: Cloudflare Dashboard
echo      - Zero Trust ^> Networks ^> Tunnels
echo      - Edit vendor.berkeleyuae.com route
echo      - Change to: http://localhost:9000
echo.
echo   2. Wait 1-2 minutes for Cloudflare to sync
echo.
echo   3. Clear browser cache (Ctrl+Shift+Delete)
echo.
echo   4. Visit: https://vendor.berkeleyuae.com
echo.
echo ========================================
echo.
echo Press any key to close...
pause
exit /b

