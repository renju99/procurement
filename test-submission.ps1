# PowerShell script to test form submission with sample data and PDF file

Write-Host "Testing Vendor Registration Form Submission" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""

# Check if Node.js is available
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js to run this test script" -ForegroundColor Yellow
    exit 1
}

# Check if PDF file exists
$pdfPath = Join-Path $PSScriptRoot "..\BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf"
if (-not (Test-Path $pdfPath)) {
    Write-Host "Warning: PDF file not found at: $pdfPath" -ForegroundColor Yellow
    Write-Host "The test will still run, but file uploads will fail" -ForegroundColor Yellow
}

# Check if backend is running
Write-Host "Checking if backend is running..." -ForegroundColor Cyan
try {
    $healthCheck = Invoke-WebRequest -Uri "http://localhost:3001/api/health" -UseBasicParsing -TimeoutSec 5
    if ($healthCheck.StatusCode -eq 200) {
        Write-Host "✓ Backend is running" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Backend is not running. Please start it first:" -ForegroundColor Red
    Write-Host "  docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Installing test dependencies..." -ForegroundColor Cyan
Set-Location $PSScriptRoot
npm install form-data --save

Write-Host ""
Write-Host "Running test submission..." -ForegroundColor Cyan
node test-submission.js

