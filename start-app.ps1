# Flutter App Startup Script with API Configuration Check
# This ensures the app uses the correct backend URL

Write-Host "🚀 Starting RailBuddy Train Booking App" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Check current API configuration
Write-Host "📡 Checking API Configuration..." -ForegroundColor Yellow
$apiConfig = Get-Content "lib\services\api_service.dart" | Select-String -Pattern 'final String baseUrl = "(.+)"'
if ($apiConfig) {
    $currentUrl = $apiConfig.Matches.Groups[1].Value
    Write-Host "   Current API URL: $currentUrl" -ForegroundColor White
    
    if ($currentUrl -like "*localhost*") {
        Write-Host "   ⚠️  WARNING: Using localhost (won't work on Android device!)" -ForegroundColor Red
        Write-Host "   Should be: http://172.16.140.134:5000" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "   Do you want to update it? (Y/N): " -ForegroundColor Yellow -NoNewline
        $response = Read-Host
        
        if ($response -eq "Y" -or $response -eq "y") {
            Write-Host "   Updating API URL..." -ForegroundColor Yellow
            $content = Get-Content "lib\services\api_service.dart" -Raw
            $content = $content -replace 'final String baseUrl = "http://localhost:5000";', 'final String baseUrl = "http://172.16.140.134:5000";'
            Set-Content "lib\services\api_service.dart" -Value $content
            Write-Host "   ✅ Updated to: http://172.16.140.134:5000" -ForegroundColor Green
        }
    } else {
        Write-Host "   ✅ Configuration looks good!" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ Could not read API configuration" -ForegroundColor Red
}
Write-Host ""

# Check if backend is running
Write-Host "🔍 Checking Backend Server..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://172.16.140.134:5000" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
    Write-Host "   ✅ Backend is running and accessible!" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Backend is NOT accessible at http://172.16.140.134:5000" -ForegroundColor Red
    Write-Host "   Please start the backend server:" -ForegroundColor Yellow
    Write-Host "   > cd backend" -ForegroundColor White
    Write-Host "   > node server.js" -ForegroundColor White
    Write-Host ""
    Write-Host "   Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host ""

# Clean build
Write-Host "🧹 Cleaning build cache..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "   ✅ Build cache cleaned" -ForegroundColor Green
Write-Host ""

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get | Out-Null
Write-Host "   ✅ Dependencies updated" -ForegroundColor Green
Write-Host ""

# Check connected devices
Write-Host "📱 Checking connected devices..." -ForegroundColor Yellow
$devices = flutter devices
Write-Host $devices
Write-Host ""

# Start the app
Write-Host "🚀 Starting Flutter app..." -ForegroundColor Yellow
Write-Host ""
Write-Host "⚡ IMPORTANT: After the app launches on your device:" -ForegroundColor Cyan
Write-Host "   1. Press 'R' (capital R) in this terminal" -ForegroundColor White
Write-Host "   2. This does a HOT RESTART to load the new configuration" -ForegroundColor White
Write-Host "   3. Do NOT press 'r' (lowercase) - that's just Hot Reload" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Run the app
flutter run
