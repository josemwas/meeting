@echo off
REM Quick Start Script for Meeting Management System Web Frontend (Windows)

echo Starting Meeting Management System Web Frontend...
echo.

REM Check if dependencies are installed
if not exist "frontend\node_modules" (
    echo Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
)

echo.
echo Dependencies ready!
echo.
echo Starting servers...
echo.

REM Start backend
echo Starting Backend API on http://localhost:8000...
start "Backend API" cmd /k "cd backend && python api.py"

REM Wait for backend to start
timeout /t 3 /nobreak > nul

REM Start frontend
echo Starting Frontend on http://localhost:3000...
start "Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo Both servers are starting!
echo.
echo Backend API: http://localhost:8000
echo Frontend UI: http://localhost:3000
echo API Docs: http://localhost:8000/docs
echo.
echo Close the terminal windows to stop the servers
echo.

pause
