@echo off
echo Starting HTTP server for vendor registration form...
echo.
echo Form will be available at: http://localhost:8000/vendor-registration-form.html
echo Backend API: http://localhost:3001/api/submit
echo.
echo Press Ctrl+C to stop the server
echo.
python -m http.server 8000

