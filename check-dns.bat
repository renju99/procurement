@echo off
echo ========================================
echo DNS Resolution Check
echo ========================================
echo.

echo 1. Checking DNS with default server...
nslookup vendor.berkeleyuae.com
echo.

echo 2. Checking DNS with Google DNS (8.8.8.8)...
nslookup vendor.berkeleyuae.com 8.8.8.8
echo.

echo 3. Checking DNS with Cloudflare DNS (1.1.1.1)...
nslookup vendor.berkeleyuae.com 1.1.1.1
echo.

echo ========================================
echo If all fail, the DNS record may be missing
echo Check Cloudflare dashboard or domain registrar
echo ========================================
pause


