# Verification script for vendor form setup
Write-Host "=== Vendor Form Setup Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check Docker containers
Write-Host "1. Checking Docker containers..." -ForegroundColor Yellow
$containers = docker ps --format "{{.Names}}" 2>$null
if ($containers -match "vendor-form-backend") {
    Write-Host "   ✓ vendor-form-backend is running" -ForegroundColor Green
} else {
    Write-Host "   ✗ vendor-form-backend is NOT running" -ForegroundColor Red
}

if ($containers -match "vendor-form-nginx") {
    Write-Host "   ✓ vendor-form-nginx is running" -ForegroundColor Green
} else {
    Write-Host "   ✗ vendor-form-nginx is NOT running" -ForegroundColor Red
}

if ($containers -match "cloudflared-tunnel") {
    Write-Host "   ✓ cloudflared-tunnel is running" -ForegroundColor Green
} else {
    Write-Host "   ✗ cloudflared-tunnel is NOT running" -ForegroundColor Red
}

if ($containers -match "vendor-form-cloudflared") {
    Write-Host "   ⚠ WARNING: vendor-form-cloudflared is still running (should be removed)" -ForegroundColor Yellow
} else {
    Write-Host "   ✓ No old vendor-form-cloudflared container (good)" -ForegroundColor Green
}

Write-Host ""

# Test localhost:9000
Write-Host "2. Testing localhost:9000..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9000/api/health" -TimeoutSec 5 -UseBasicParsing 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✓ localhost:9000 is accessible" -ForegroundColor Green
        Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ localhost:9000 is NOT accessible" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host ""

# Test public domain
Write-Host "3. Testing public domain (vendor.berkeleyuae.com)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://vendor.berkeleyuae.com/api/health" -TimeoutSec 10 -UseBasicParsing 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✓ vendor.berkeleyuae.com is accessible" -ForegroundColor Green
        Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ vendor.berkeleyuae.com is NOT accessible" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
    Write-Host "   Note: This might be normal if services aren't running yet" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Verification Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  - If services aren't running: docker-compose -f docker-compose-cloudflare.yml up -d" -ForegroundColor White
Write-Host "  - Check logs: docker logs vendor-form-backend" -ForegroundColor White
Write-Host "  - Check logs: docker logs vendor-form-nginx" -ForegroundColor White


