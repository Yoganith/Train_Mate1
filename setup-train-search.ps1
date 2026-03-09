# Train Search Feature Setup Script

Write-Host "🚆 Train Search Feature Setup" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check MongoDB
Write-Host "1️⃣ Checking MongoDB..." -ForegroundColor Yellow
$mongoProcess = Get-Process -Name mongod -ErrorAction SilentlyContinue
if ($mongoProcess) {
    Write-Host "   ✅ MongoDB is running" -ForegroundColor Green
} else {
    Write-Host "   ❌ MongoDB is not running!" -ForegroundColor Red
    Write-Host "   Please start MongoDB first" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Step 2: Seed train data
Write-Host "2️⃣ Seeding train data..." -ForegroundColor Yellow
Push-Location backend
try {
    node seed-trains.js
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Train data seeded successfully!" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Failed to seed train data" -ForegroundColor Red
        exit 1
    }
} finally {
    Pop-Location
}
Write-Host ""

# Step 3: Test search endpoint
Write-Host "3️⃣ Testing search endpoint..." -ForegroundColor Yellow
try {
    $result = Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=delhi&to=mumbai" -ErrorAction Stop
    Write-Host "   ✅ Search endpoint working!" -ForegroundColor Green
    Write-Host "   Found $($result.Count) trains" -ForegroundColor Cyan
} catch {
    Write-Host "   ❌ Backend not running or search endpoint error" -ForegroundColor Red
    Write-Host "   Make sure backend is running: node backend/server.js" -ForegroundColor Yellow
}
Write-Host ""

# Summary
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔍 Test the search:" -ForegroundColor Yellow
Write-Host "   Invoke-RestMethod -Uri 'http://localhost:5000/api/trains/search?from=delhi&to=mumbai'" -ForegroundColor White
Write-Host ""
Write-Host "📊 View in MongoDB Compass:" -ForegroundColor Yellow
Write-Host "   1. Connect to: mongodb://localhost:27017" -ForegroundColor White
Write-Host "   2. Database: train_booking" -ForegroundColor White
Write-Host "   3. Collection: trains (16 trains)" -ForegroundColor White
Write-Host ""
Write-Host "📖 Full Guide: TRAIN_SEARCH_GUIDE.md" -ForegroundColor Magenta
Write-Host ""
