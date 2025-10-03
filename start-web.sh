#!/bin/bash

# Quick Start Script for Meeting Management System Web Frontend
# This script helps you start both the backend API and frontend dev server

echo "🚀 Starting Meeting Management System Web Frontend..."
echo ""

# Check if dependencies are installed
if [ ! -d "frontend/node_modules" ]; then
    echo "📦 Installing frontend dependencies..."
    cd frontend && npm install && cd ..
fi

if ! pip show fastapi &> /dev/null; then
    echo "📦 Installing backend dependencies..."
    pip install -r backend/requirements.txt
fi

echo ""
echo "✅ Dependencies installed!"
echo ""
echo "Starting servers..."
echo ""

# Start backend in background
echo "🔧 Starting Backend API on http://localhost:8000..."
cd backend && python api.py &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 2

# Start frontend
echo "🎨 Starting Frontend on http://localhost:3000..."
cd frontend && npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "✅ Both servers are starting!"
echo ""
echo "📍 Backend API: http://localhost:8000"
echo "📍 Frontend UI: http://localhost:3000"
echo "📍 API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for Ctrl+C
trap "echo ''; echo '🛑 Stopping servers...'; kill $BACKEND_PID $FRONTEND_PID; exit" INT

# Keep script running
wait
