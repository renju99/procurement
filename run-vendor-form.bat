@echo off
setlocal enabledelayedexpansion
title Vendor Form Services - Port 9000
color 0B

echo.
echo ========================================
echo   VENDOR FORM SERVICES
echo   Port: 9000
echo ========================================
echo.

cd /d "%~dp0"

REM Check if Docker is available
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not in PATH
    echo.
    echo Please install Docker Desktop and try again.
    echo.
    goto :end
)

echo [1/4] Checking existing containers...
docker ps -a --filter "name=vendor-form" --format "{{.Names}}" >nul 2>&1
if errorlevel 0 (
    echo   Found existing containers
)

echo.
echo [2/4] Stopping existing containers...
docker-compose -f docker-compose-nginx.yml down >nul 2>&1
echo   Done

echo.
echo [3/4] Starting services on port 9000...
docker-compose -f docker-compose-nginx.yml up -d
if errorlevel 1 (
    echo.
    echo ERROR: Failed to start services!
    echo Check Docker Desktop is running.
    echo.
    goto :end
)
echo   Services started

echo.
echo [4/4] Waiting for services to initialize (15 seconds)...
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo   CONTAINER STATUS
echo ========================================
echo.
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ========================================
echo   TESTING PORT 9000
echo ========================================
echo.

REM Test the health endpoint
curl -s -m 5 http://localhost:9000/api/health >nul 2>&1
if errorlevel 0 (
    echo   SUCCESS: Port 9000 is responding!
    echo.
    curl -s http://localhost:9000/api/health
    echo.
    echo.
) else (
    echo   WARNING: Port 9000 not responding yet
    echo   Services may still be starting...
    echo.
    echo   Checking logs...
    echo.
    docker logs vendor-form-nginx --tail 10 2>nul
    echo.
)

echo.
echo ========================================
echo   IMPORTANT: UPDATE CLOUDFLARE ROUTE
echo ========================================
echo.
echo   1. Go to: https://dash.cloudflare.com
echo   2. Zero Trust ^> Networks ^> Tunnels
echo   3. Click your tunnel
echo   4. Edit vendor.berkeleyuae.com route
echo   5. Change Service URL to: http://localhost:9000
echo   6. Save
echo.
echo   Then wait 1-2 minutes and visit:
echo   https://vendor.berkeleyuae.com
echo.
echo ========================================
echo.

:end
echo.
echo Press any key to close this window...
pause >nul 2>&1
if errorlevel 1 (
    echo.
    echo (If window closes immediately, run from Command Prompt)
    timeout /t 10
)
endlocal



