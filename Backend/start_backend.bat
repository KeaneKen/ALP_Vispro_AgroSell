@echo off
echo ========================================
echo Starting AgroSell Backend Server
echo ========================================
echo.

echo Checking database connection...
php test_api.php
echo.

echo ----------------------------------------
echo Starting Laravel server...
echo ----------------------------------------
echo.
echo The backend will run at: http://0.0.0.0:8000
echo API endpoints at: http://0.0.0.0:8000/api
echo.
echo Press Ctrl+C to stop the server
echo.

php artisan serve --host=0.0.0.0 --port=8000
