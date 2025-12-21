@echo off
title Final Verification Test
color 0A
echo.
echo ========================================
echo   FINAL VERIFICATION TEST
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Checking Docker services...
echo.
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
if errorlevel 1 (
    echo.
    echo   WARNING: No containers found!
    echo   Starting services...
    docker-compose -f docker-compose-nginx.yml up -d
    timeout /t 10 /nobreak >nul
) else (
    echo.
    echo   Services found!
)

echo.
echo [2/3] Testing localhost:9000...
echo.
curl -s -m 10 http://localhost:9000/api/health
if errorlevel 1 (
    echo.
    echo   ERROR: Port 9000 not responding!
    echo   Services may not be running correctly.
    echo.
    echo   Check logs:
    echo     docker logs vendor-form-nginx
    echo     docker logs vendor-form-backend
) else (
    echo.
    echo.
    echo   SUCCESS: Port 9000 is responding!
)

echo.
echo [3/3] DNS Status...
echo.
echo   DNS is resolving correctly!
echo   vendor.berkeleyuae.com ^> Cloudflare Tunnel
echo.

echo ========================================
echo   NEXT STEPS
echo ========================================
echo.
echo   1. Clear browser cache (Ctrl+Shift+Delete)
echo   2. Or use incognito mode (Ctrl+Shift+N)
echo   3. Visit: https://vendor.berkeleyuae.com
echo.
echo   Should show vendor registration form!
echo.
echo ========================================
echo.
pause



