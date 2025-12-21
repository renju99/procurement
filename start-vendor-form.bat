@echo off
echo ========================================
echo Starting Vendor Form Services
echo ========================================
echo.

cd /d "%~dp0"

echo Checking Docker...
docker --version
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not in PATH
    pause
    exit /b 1
)

echo.
echo Stopping any existing containers...
docker-compose -f docker-compose-nginx.yml down

echo.
echo Starting services...
docker-compose -f docker-compose-nginx.yml up -d

echo.
echo Waiting for services to start...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo Service Status:
echo ========================================
docker ps --filter "name=vendor-form" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ========================================
echo Testing local endpoint...
echo ========================================
curl -s http://localhost:8080/api/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Services are running successfully!
    echo.
    echo Your form should be accessible at:
    echo   https://vendor.berkeleyuae.com
) else (
    echo.
    echo ⚠ Could not reach localhost:8080
    echo Check logs with: docker logs vendor-form-nginx
)

echo.
echo ========================================
echo View logs:
echo   docker logs vendor-form-nginx
echo   docker logs vendor-form-backend
echo ========================================
echo.
pause



