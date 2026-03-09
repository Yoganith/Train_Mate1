# Backend Connection Setup for Android Device/Emulator

## Problem
When running the Flutter app on Android, it cannot connect to `localhost:5000` because localhost refers to the Android device itself, not your computer.

## Solution Applied

### 1. ✅ Updated API Service
**File**: `lib/services/api_service.dart`
- Changed from: `http://localhost:5000`
- Changed to: `http://172.16.140.134:5000`
- This is your computer's IP address on the local network

### 2. ✅ Updated Backend Server
**File**: `backend/server.js`
- Server now listens on `0.0.0.0` (all network interfaces)
- This allows connections from your local network, not just localhost

## Steps to Run

### Step 1: Start MongoDB
Make sure MongoDB is running:
```bash
# Windows
net start MongoDB

# Or if using MongoDB Community Edition
mongod
```

### Step 2: Start Backend Server
```bash
cd backend
npm install   # First time only
node server.js
```

You should see:
```
🚆 Backend running on port 5000
   Local:   http://localhost:5000
   Network: http://172.16.140.134:5000
   API Routes:
   - POST /api/auth/register
   - POST /api/auth/login
   - GET  /api/trains
   - POST /api/bookings
```

### Step 3: Configure Windows Firewall (If Needed)

If you still can't connect, allow Node.js through Windows Firewall:

**Option A: Allow Port 5000**
```powershell
# Run PowerShell as Administrator
New-NetFirewallRule -DisplayName "Node Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

**Option B: Temporarily Disable Firewall (Not Recommended)**
- Go to Windows Security → Firewall & network protection
- Turn off for Private networks (only during development)

### Step 4: Test Backend Connection

**From your computer (browser):**
```
http://localhost:5000
```
Should show: "🚆 Train Booking API is running!"

**From Android device (if on same WiFi):**
```
http://172.16.140.134:5000
```
Should show the same message

### Step 5: Run Flutter App
```bash
flutter run
```

## Alternative: Using Android Emulator Special IP

If using Android Emulator (not physical device), you can also use:
```dart
final String baseUrl = "http://10.0.2.2:5000";
```

The IP `10.0.2.2` is a special alias to your host machine's loopback interface (localhost).

**NOTE**: This ONLY works for Android Emulator, not physical devices.

## Troubleshooting

### Error: Connection Refused
**Cause**: Backend server not running or firewall blocking

**Solutions**:
1. Make sure backend is running with `node server.js`
2. Check firewall settings (see Step 3 above)
3. Verify IP address with `ipconfig` command

### Error: Network Unreachable
**Cause**: Device not on same network as computer

**Solutions**:
1. Make sure phone and computer are on same WiFi network
2. Check if IP address has changed (run `ipconfig` again)
3. Update `api_service.dart` with new IP if needed

### Error: Timeout
**Cause**: Server taking too long to respond

**Solutions**:
1. Check MongoDB is running
2. Check backend logs for errors
3. Restart backend server

### Backend logs show nothing
**Cause**: Request not reaching backend

**Solutions**:
1. Confirm firewall is allowing port 5000
2. Check antivirus isn't blocking Node.js
3. Try using emulator with 10.0.2.2 instead

## Quick Health Check

### Test 1: Backend Running?
```bash
curl http://localhost:5000
```
Expected: "🚆 Train Booking API is running!"

### Test 2: Backend Accessible from Network?
```bash
curl http://172.16.140.134:5000
```
Expected: Same message

### Test 3: Login Endpoint?
```bash
curl -X POST http://172.16.140.134:5000/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"test@test.com\",\"password\":\"test123\"}"
```
Expected: JSON response (even if error, it means endpoint is reachable)

## For Production Deployment

When deploying to production:
1. Update `api_service.dart` with your production backend URL
2. Use HTTPS instead of HTTP
3. Update server to listen on appropriate port
4. Configure proper CORS settings
5. Add authentication tokens/headers

## Summary of Changes

✅ **API Service** (`lib/services/api_service.dart`):
- Base URL: `http://172.16.140.134:5000`

✅ **Backend Server** (`backend/server.js`):
- Listening on: `0.0.0.0:5000` (all interfaces)

✅ **Firewall**: May need to allow port 5000

---

**Current Network Configuration**:
- Computer IP: `172.16.140.134`
- Backend Port: `5000`
- Full URL: `http://172.16.140.134:5000`
