Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking Vendor Form Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker containers
Write-Host "1. Checking Docker containers..." -ForegroundColor Yellow
$containers = docker ps --filter "name=vendor-form" --format "{{.Names}}|{{.Status}}|{{.Ports}}"
if ($containers) {
    Write-Host "   Containers found:" -ForegroundColor Green
    $containers | ForEach-Object {
        $parts = $_ -split '\|'
        Write-Host "   - $($parts[0]): $($parts[1])" -ForegroundColor Green
        if ($parts[2] -match '8080') {
            Write-Host "     ✓ Port 8080 is mapped correctly" -ForegroundColor Green
        } else {
            Write-Host "     ⚠ Port 8080 not found in mapping: $($parts[2])" -ForegroundColor Red
        }
    }
} else {
    Write-Host "   ⚠ No vendor-form containers running!" -ForegroundColor Red
    Write-Host "   Run: docker-compose -f docker-compose-nginx.yml up -d" -ForegroundColor Yellow
}

Write-Host ""

# Check if port 8080 is listening
Write-Host "2. Checking if port 8080 is accessible..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/health" -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✓ Port 8080 is responding!" -ForegroundColor Green
        Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ⚠ Port 8080 is not responding" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Check what's on port 443 (3CX)
Write-Host "3. Checking port 443 (3CX)..." -ForegroundColor Yellow
try {
    $response443 = Invoke-WebRequest -Uri "https://localhost:443" -TimeoutSec 5 -UseBasicParsing -SkipCertificateCheck
    Write-Host "   ⚠ Port 443 is responding (this is 3CX)" -ForegroundColor Yellow
    Write-Host "   This confirms 3CX is on port 443" -ForegroundColor Gray
} catch {
    Write-Host "   Port 443 not accessible (expected)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Update Cloudflare Route!" -ForegroundColor Red
Write-Host ""
Write-Host "Go to Cloudflare Dashboard → Zero Trust → Networks → Tunnels" -ForegroundColor Yellow
Write-Host "Edit the route for vendor.berkeleyuae.com" -ForegroundColor Yellow
Write-Host "Change Service URL to: http://localhost:8080" -ForegroundColor Green
Write-Host ""
Write-Host "Current route might be pointing to:" -ForegroundColor Yellow
Write-Host "  ❌ https://localhost:443 (3CX)" -ForegroundColor Red
Write-Host "  ❌ https://localhost:8443" -ForegroundColor Red
Write-Host "  ✅ http://localhost:8080 (Correct!)" -ForegroundColor Green
Write-Host ""



