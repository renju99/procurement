@echo off
title Vendor Form Setup
echo ========================================
echo Starting and Verifying Vendor Form
echo ========================================
echo.

cd /d "%~dp0"

REM Keep window open even on error
setlocal enabledelayedexpansion

echo [1/4] Stopping any existing containers...
docker-compose -f docker-compose-nginx.yml down

echo.
echo [2/4] Starting services...
docker-compose -f docker-compose-nginx.yml up -d

echo.
echo [3/4] Waiting for services to start (10 seconds)...
timeout /t 10 /nobreak >nul

echo.
echo [4/4] Verifying services...
echo.

echo Checking containers...
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo Testing localhost:9000...
curl -s http://localhost:9000/api/health
if %errorlevel% equ 0 (
    echo.
    echo.
    echo ========================================
    echo SUCCESS! Services are running!
    echo ========================================
    echo.
    echo Your form should be accessible at:
    echo   https://vendor.berkeleyuae.com
    echo.
    echo IMPORTANT: Clear your browser cache or use incognito mode!
    echo.
) else (
    echo.
    echo.
    echo ========================================
    echo WARNING: Port 9000 not responding
    echo ========================================
    echo.
    echo Checking logs...
    echo.
    echo --- Nginx Logs (last 20 lines) ---
    docker logs vendor-form-nginx --tail 20
    echo.
    echo --- Backend Logs (last 20 lines) ---
    docker logs vendor-form-backend --tail 20
    echo.
)

echo.
echo ========================================
echo Done!
echo ========================================
echo.
echo ========================================
echo IMPORTANT: Update Cloudflare Route!
echo ========================================
echo.
echo Go to Cloudflare Dashboard:
echo   Zero Trust ^> Networks ^> Tunnels
echo.
echo Update vendor.berkeleyuae.com route:
echo   Change from: http://localhost:8080
echo   Change to:   http://localhost:9000
echo.
echo ========================================
echo.
pause
endlocal
exit /b

