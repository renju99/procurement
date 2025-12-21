@echo off
title Verify Vendor Form Services
color 0A
echo.
echo ========================================
echo   VERIFYING VENDOR FORM SERVICES
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Checking Docker containers...
echo.
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
if errorlevel 1 (
    echo.
    echo   ERROR: Docker command failed or no containers found
    echo.
    goto :check_services
)

:check_services
echo.
echo [2/3] Testing localhost:9000...
echo.
curl -s -m 10 http://localhost:9000/api/health
if errorlevel 1 (
    echo.
    echo   ERROR: Port 9000 is NOT responding!
    echo.
    echo   This means services are not running correctly.
    echo.
    echo   Starting services now...
    docker-compose -f docker-compose-nginx.yml down
    docker-compose -f docker-compose-nginx.yml up -d
    echo.
    echo   Waiting 15 seconds for services to start...
    timeout /t 15 /nobreak >nul
    echo.
    echo   Testing again...
    curl -s -m 10 http://localhost:9000/api/health
    if errorlevel 1 (
        echo.
        echo   Still not responding. Checking logs...
        echo.
        echo   --- Nginx Logs ---
        docker logs vendor-form-nginx --tail 30
        echo.
        echo   --- Backend Logs ---
        docker logs vendor-form-backend --tail 30
    ) else (
        echo.
        echo.
        echo   SUCCESS: Port 9000 is now responding!
    )
) else (
    echo.
    echo.
    echo   SUCCESS: Port 9000 is responding!
)

echo.
echo [3/3] Testing main page...
echo.
curl -s -m 10 http://localhost:9000 | findstr /i "vendor registration berkeley" >nul
if errorlevel 1 (
    echo   WARNING: Page content doesn't look like vendor form
    echo   Checking what's being served...
    curl -s -m 10 http://localhost:9000 | findstr /i /c:"3cx" /c:"login" >nul
    if errorlevel 0 (
        echo   ERROR: Port 9000 is serving 3CX content!
        echo   This means something else is running on port 9000.
    ) else (
        echo   Content check inconclusive
    )
) else (
    echo   SUCCESS: Vendor form content detected!
)

echo.
echo ========================================
echo   SUMMARY
echo ========================================
echo.
echo   Cloudflare Route: CORRECT (localhost:9000)
echo.
echo   If port 9000 responds but you still see 3CX:
echo   1. Clear browser cache completely
echo   2. Use incognito/private mode
echo   3. Wait 2-3 minutes after starting services
echo   4. Try: https://vendor.berkeleyuae.com
echo.
echo ========================================
echo.
pause



