@echo off
echo Starting Soketi WebSocket Server...
echo ===================================
echo.
echo WebSocket server will run on port 6001
echo Press Ctrl+C to stop the server
echo.
soketi start --config=soketi.json
pause
