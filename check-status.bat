@echo off
title Vendor Form Status Check
color 0E
echo.
echo ========================================
echo   VENDOR FORM STATUS CHECK
echo ========================================
echo.

cd /d "%~dp0"

echo [1] Checking Docker containers...
echo.
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
if errorlevel 1 (
    echo.
    echo   WARNING: No containers found or Docker not running
    echo.
) else (
    echo.
    echo   Containers found!
    echo.
)

echo [2] Testing port 9000...
echo.
curl -s -m 5 http://localhost:9000/api/health
if errorlevel 1 (
    echo.
    echo   ERROR: Port 9000 is NOT responding
    echo.
    echo   This means services are not running correctly.
    echo   Run: docker-compose -f docker-compose-nginx.yml up -d
    echo.
) else (
    echo.
    echo.
    echo   SUCCESS: Port 9000 is responding!
    echo.
)

echo [3] Checking Cloudflare Route...
echo.
echo   IMPORTANT: Verify in Cloudflare Dashboard:
echo   - Route should point to: http://localhost:9000
echo   - NOT: http://localhost:8080
echo   - NOT: https://localhost:443
echo   - NOT: https://localhost:8443
echo.

echo ========================================
echo   SUMMARY
echo ========================================
echo.
echo   If port 9000 responds but you still see 3CX:
echo   1. Update Cloudflare route to port 9000
echo   2. Wait 2-3 minutes
echo   3. Clear browser cache
echo   4. Try incognito mode
echo.
echo ========================================
echo.
pause



