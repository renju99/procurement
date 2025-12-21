# PowerShell script to serve the form
Write-Host "Starting HTTP server for vendor registration form..." -ForegroundColor Green
Write-Host ""
Write-Host "Form will be available at: http://localhost:8000/vendor-registration-form.html" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:3001/api/submit" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Check if Python is available
if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m http.server 8000
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    python3 -m http.server 8000
} else {
    Write-Host "Python not found. Installing http-server via npm..." -ForegroundColor Yellow
    if (Get-Command npx -ErrorAction SilentlyContinue) {
        npx http-server -p 8000
    } else {
        Write-Host "Error: Neither Python nor Node.js found. Please install one of them." -ForegroundColor Red
        Write-Host "Or use: npx http-server -p 8000" -ForegroundColor Yellow
    }
}

