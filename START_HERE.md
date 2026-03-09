# 🚀 Quick Start Guide - RailBuddy Train Booking App

## Current Status
✅ **Backend is accessible**: `http://172.16.140.134:5000`  
✅ **API Service updated**: Using network IP instead of localhost  
✅ **Flutter build cleaned**: Ready for fresh rebuild

---

## 📋 Steps to Run the App

### Step 1: Start Backend Server (If Not Running)
```bash
cd backend
node server.js
```

**Expected Output:**
```
🚆 Backend running on port 5000
   Local:   http://localhost:5000
   Network: http://172.16.140.134:5000
   API Routes:
   - POST /api/auth/register
   - POST /api/auth/login
   - GET  /api/trains
   - POST /api/bookings
✅ MongoDB connected
```

### Step 2: Build and Run Flutter App

**Option A: Run on connected Android device**
```bash
flutter run
```

**Option B: Build APK for installation**
```bash
flutter build apk --debug
```
The APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

### Step 3: Hot Restart After Running
Once the app launches:
1. Press `R` (capital R) in the terminal to do a **Hot Restart**
2. This ensures all changes are loaded

---

## 🔥 If You Still Get "Connection Refused"

### Solution 1: Hot Restart (Not Hot Reload)
After the app starts, press:
- **`R`** (capital R) - Hot Restart ✅
- **NOT `r`** (lowercase r) - Hot Reload ❌

### Solution 2: Stop and Rebuild
```bash
# Stop the running app (Ctrl+C in terminal)
flutter clean
flutter pub get
flutter run
# Then press R for hot restart
```

### Solution 3: Configure Firewall
Run PowerShell as Administrator:
```powershell
New-NetFirewallRule -DisplayName "Node Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

Or use the provided script:
```powershell
# Right-click PowerShell → Run as Administrator
.\allow-backend-port.ps1
```

### Solution 4: Check Network Connection
Make sure:
1. ✅ Android device and computer are on **same WiFi network**
2. ✅ Backend server is **running**
3. ✅ You can access `http://172.16.140.134:5000` in your computer's browser

---

## 🧪 Test Backend Connection

### Test 1: From Your Computer
Open browser and go to:
```
http://172.16.140.134:5000
```
**Expected**: "🚆 Train Booking API is running!"

### Test 2: From Terminal
```bash
curl http://172.16.140.134:5000
```
**Expected**: Status 200 OK

### Test 3: Test Register Endpoint
```bash
curl -X POST http://172.16.140.134:5000/api/auth/register -H "Content-Type: application/json" -d "{\"name\":\"Test\",\"email\":\"test@test.com\",\"password\":\"test123\"}"
```
**Expected**: JSON response (even if error, means endpoint is reachable)

---

## 📱 Alternative: Use Android Emulator

If using Android Emulator (not physical device), you can use the special alias:

**Update** `lib/services/api_service.dart`:
```dart
final String baseUrl = "http://10.0.2.2:5000";
```

Then:
```bash
flutter clean
flutter pub get
flutter run
```

**NOTE**: `10.0.2.2` ONLY works for Android Emulator, not physical devices!

---

## ❓ Troubleshooting

### Still seeing "localhost" in error?
The app is using cached code. Do a **complete rebuild**:
```bash
# Stop the app (Ctrl+C)
flutter clean
flutter pub get
flutter run
# Once started, press R (Hot Restart)
```

### Backend not starting?
Check if MongoDB is running:
```bash
# Windows
net start MongoDB

# Check MongoDB status
mongo --eval "db.runCommand({ connectionStatus: 1 })"
```

### IP Address Changed?
Your computer's IP might change. Check with:
```bash
ipconfig
```
Then update `lib/services/api_service.dart` with the new IP.

---

## 📂 Important Files

| File | Purpose |
|------|---------|
| `lib/services/api_service.dart` | Backend URL configuration |
| `backend/server.js` | Backend server entry point |
| `BACKEND_SETUP.md` | Detailed setup guide |
| `allow-backend-port.ps1` | Firewall configuration script |

---

## ✅ Current Configuration

```
Computer IP:    172.16.140.134
Backend Port:   5000
Full URL:       http://172.16.140.134:5000
MongoDB:        localhost:27017
```

---

## 🎯 Quick Commands Reference

```bash
# Clean and rebuild
flutter clean && flutter pub get && flutter run

# Build APK
flutter build apk --debug

# Check connected devices
flutter devices

# Hot Restart (press in running app terminal)
R

# Hot Reload (press in running app terminal)
r

# Stop app
Ctrl + C

# Backend server
cd backend && node server.js

# Check IP address
ipconfig
```

---

## 📞 Need Help?

If you're still having issues:
1. Check `BACKEND_SETUP.md` for detailed troubleshooting
2. Make sure both computer and phone are on same WiFi
3. Verify backend is running with `curl http://172.16.140.134:5000`
4. Try hot restart (press `R` after app starts)

**Remember**: Always do a **Hot Restart (R)** after starting the app to ensure all changes are loaded!
