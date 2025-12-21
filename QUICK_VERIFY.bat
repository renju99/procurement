@echo off
echo ========================================
echo Quick Verification
echo ========================================
echo.

echo Checking containers...
docker ps --format "{{.Names}}" | findstr /i "vendor-form cloudflared"
echo.

echo Testing localhost:9000...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://localhost:9000/api/health
echo.

echo Testing public domain...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" https://vendor.berkeleyuae.com/api/health
echo.

echo ========================================
echo Done! Check the HTTP status codes above.
echo 200 = OK, anything else = needs attention
echo ========================================
pause


