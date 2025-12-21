Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verifying Vendor Form Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if containers are running
Write-Host "Step 1: Checking Docker containers..." -ForegroundColor Yellow
$containers = docker ps --filter "name=vendor-form" --format "{{.Names}}|{{.Status}}|{{.Ports}}"
if ($containers) {
    Write-Host "   ✓ Containers found:" -ForegroundColor Green
    $containers | ForEach-Object {
        $parts = $_ -split '\|'
        Write-Host "   - $($parts[0]): $($parts[1])" -ForegroundColor Green
        if ($parts[2] -match '9000') {
            Write-Host "     ✓ Port 9000 is mapped" -ForegroundColor Green
        } elseif ($parts[2] -eq '') {
            Write-Host "     ⚠ No port mapping shown" -ForegroundColor Yellow
        } else {
            Write-Host "     Ports: $($parts[2])" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "   ⚠ No vendor-form containers running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Starting services..." -ForegroundColor Yellow
    docker-compose -f docker-compose-nginx.yml up -d
    Start-Sleep -Seconds 5
    Write-Host "   ✓ Services started" -ForegroundColor Green
}

Write-Host ""

# Step 2: Test localhost:9000
Write-Host "Step 2: Testing localhost:9000..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9000/api/health" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✓ Port 9000 is responding!" -ForegroundColor Green
        Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
        
        # Test the main page
        try {
            $pageResponse = Invoke-WebRequest -Uri "http://localhost:9000" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
            if ($pageResponse.Content -match 'BERKELEY.*VENDOR.*REGISTRATION' -or $pageResponse.Content -match 'vendor.*registration' -or $pageResponse.Content -match 'companyName') {
                Write-Host "   ✓ Vendor form is being served!" -ForegroundColor Green
            } else {
                Write-Host "   ⚠ Port 8080 responds but content doesn't look like vendor form" -ForegroundColor Yellow
                Write-Host "   Content preview: $($pageResponse.Content.Substring(0, [Math]::Min(200, $pageResponse.Content.Length)))" -ForegroundColor Gray
            }
        } catch {
            Write-Host "   ⚠ Could not fetch main page: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "   ✗ Port 9000 is NOT responding" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Troubleshooting:" -ForegroundColor Yellow
    Write-Host "   1. Check if containers are running: docker ps" -ForegroundColor White
    Write-Host "   2. Check nginx logs: docker logs vendor-form-nginx" -ForegroundColor White
    Write-Host "   3. Check backend logs: docker logs vendor-form-backend" -ForegroundColor White
    Write-Host "   4. Restart services: docker-compose -f docker-compose-nginx.yml restart" -ForegroundColor White
}

Write-Host ""

# Step 3: Check what's on port 443 (3CX)
Write-Host "Step 3: Checking port 443 (3CX)..." -ForegroundColor Yellow
try {
    $response443 = Invoke-WebRequest -Uri "https://localhost:443" -TimeoutSec 3 -UseBasicParsing -SkipCertificateCheck -ErrorAction SilentlyContinue
    Write-Host "   ⚠ Port 443 is responding (this is 3CX)" -ForegroundColor Yellow
} catch {
    Write-Host "   Port 443 not accessible (expected)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Cloudflare Route: ⚠ Update needed (vendor.berkeleyuae.com → localhost:9000)" -ForegroundColor Yellow
Write-Host "   Go to Cloudflare Dashboard and update route to port 9000!" -ForegroundColor Yellow
Write-Host ""

if ($containers) {
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. UPDATE CLOUDFLARE ROUTE to point to localhost:9000" -ForegroundColor Red
    Write-Host "2. If port 9000 is responding, wait 1-2 minutes for Cloudflare to sync" -ForegroundColor White
    Write-Host "3. Clear browser cache (Ctrl+Shift+Delete)" -ForegroundColor White
    Write-Host "4. Try incognito/private mode" -ForegroundColor White
    Write-Host "5. Visit: https://vendor.berkeleyuae.com" -ForegroundColor White
} else {
    Write-Host "Services need to be started. Run:" -ForegroundColor Yellow
    Write-Host "  docker-compose -f docker-compose-nginx.yml up -d" -ForegroundColor White
}

Write-Host ""

