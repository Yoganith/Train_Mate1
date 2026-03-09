# Allow Backend Port 5000 through Windows Firewall
# Run this script as Administrator

Write-Host "🔥 Configuring Windows Firewall for Backend Server..." -ForegroundColor Cyan

# Check if rule already exists
$existingRule = Get-NetFirewallRule -DisplayName "Node Backend Port 5000" -ErrorAction SilentlyContinue

if ($existingRule) {
    Write-Host "✅ Firewall rule already exists!" -ForegroundColor Green
    Write-Host "   Rule Name: Node Backend Port 5000" -ForegroundColor Yellow
    Write-Host "   Port: 5000 TCP" -ForegroundColor Yellow
    Write-Host "   Action: Allow" -ForegroundColor Yellow
} else {
    Write-Host "Creating new firewall rule..." -ForegroundColor Yellow
    
    try {
        New-NetFirewallRule `
            -DisplayName "Node Backend Port 5000" `
            -Direction Inbound `
            -LocalPort 5000 `
            -Protocol TCP `
            -Action Allow `
            -Profile Private,Domain `
            -Description "Allow incoming connections to Node.js backend server on port 5000"
        
        Write-Host "✅ Firewall rule created successfully!" -ForegroundColor Green
        Write-Host "   Backend server on port 5000 is now accessible from local network" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error creating firewall rule: $_" -ForegroundColor Red
        Write-Host "   Please run this script as Administrator" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "📱 You can now connect from Android device using:" -ForegroundColor Cyan
Write-Host "   http://172.16.140.134:5000" -ForegroundColor White
Write-Host ""
Write-Host "🧪 Test the connection:" -ForegroundColor Cyan
Write-Host "   Browser: http://172.16.140.134:5000" -ForegroundColor White
Write-Host ""

# Test if backend is running
Write-Host "Testing backend connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 2
    Write-Host "✅ Backend is running!" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "⚠️  Backend not responding on http://localhost:5000" -ForegroundColor Yellow
    Write-Host "   Make sure to start the backend with: node server.js" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
