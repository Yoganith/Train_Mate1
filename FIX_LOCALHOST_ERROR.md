# 🔧 FIX: Connection Refused (localhost) Error

## The Problem
Your app is still using `localhost:5000` because Flutter cached the old code. Even though we updated the API service, the running app hasn't loaded the changes.

## ✅ THE FIX - Follow These Steps EXACTLY

### Method 1: Use the Startup Script (EASIEST)

1. **Make sure backend is running** (in a separate terminal):
```powershell
cd backend
node server.js
```

2. **Run the startup script**:
```powershell
.\start-app.ps1
```

This script will:
- ✅ Check API configuration
- ✅ Verify backend is accessible
- ✅ Clean build cache
- ✅ Get dependencies
- ✅ Start the app

3. **After app launches on your phone:**
   - Press **`R`** (capital R) in the terminal
   - This does a **HOT RESTART** to load the new URL
   - Wait 5-10 seconds
   - Try registering/login again

---

### Method 2: Manual Steps

If the script doesn't work, do this manually:

#### Step 1: STOP the App Completely
- In the terminal where Flutter is running, press `Ctrl+C`
- Wait until it fully stops (you see the command prompt)

#### Step 2: Clean Everything
```powershell
flutter clean
flutter pub get
```

#### Step 3: Run the App
```powershell
flutter run
```

#### Step 4: HOT RESTART (CRITICAL!)
Once the app launches on your device:
1. Go back to the terminal
2. Press **`R`** (capital R) - NOT `r` (lowercase)
3. Wait for "Performing hot restart..."
4. Wait 5-10 seconds for app to reload
5. Now try login/registration

---

## 🎯 What is Hot Restart vs Hot Reload?

| Action | Key | What it does | Will it fix? |
|--------|-----|--------------|--------------|
| **Hot Restart** | `R` | Completely restarts app, loads new config | ✅ YES |
| **Hot Reload** | `r` | Only refreshes UI, keeps old config | ❌ NO |

You MUST use **Hot Restart (R)** to apply the API URL change!

---

## ✅ Verify It's Working

After Hot Restart, check the Flutter console when you try to login. You should see:

**BEFORE (Wrong):**
```
I/flutter: SignIn Error: ... uri=http://localhost:5000/api/auth/login
```

**AFTER (Correct):**
```
I/flutter: SignIn Error: ... uri=http://172.16.140.134:5000/api/auth/login
```

If you still see `localhost`, do another Hot Restart (press `R` again).

---

## 🔍 Still Not Working?

### 1. Check API Service File
```powershell
Get-Content lib\services\api_service.dart | Select-String "baseUrl"
```

Should show:
```dart
final String baseUrl = "http://172.16.140.134:5000";
```

If it shows `localhost`, update it:
```powershell
# Edit the file and change localhost to 172.16.140.134
# Then run: flutter clean && flutter pub get && flutter run
```

### 2. Check Backend is Running
```powershell
curl http://172.16.140.134:5000
```

Should show: "🚆 Train Booking API is running!"

If not, start backend:
```powershell
cd backend
node server.js
```

### 3. Check Firewall
Run PowerShell as Administrator:
```powershell
New-NetFirewallRule -DisplayName "Node Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

### 4. Nuclear Option - Complete Reset
```powershell
# Stop app (Ctrl+C)
flutter clean
Remove-Item -Recurse -Force build
Remove-Item -Recurse -Force .dart_tool
flutter pub get
flutter run
# Wait for app to launch
# Press R (Hot Restart)
# Try login/registration
```

---

## 📝 Quick Checklist

Before running the app, verify:

- [ ] Backend is running (`node server.js` in backend folder)
- [ ] Backend is accessible (`curl http://172.16.140.134:5000`)
- [ ] API service uses correct URL (not localhost)
- [ ] Flutter build is clean (`flutter clean`)
- [ ] Phone and computer on same WiFi
- [ ] After app launches, press **R** for Hot Restart

---

## 🎯 Success Indicators

You'll know it's working when:

1. ✅ Error message shows `172.16.140.134:5000` (not localhost)
2. ✅ Backend console shows incoming requests
3. ✅ Registration/Login works without connection error

---

## 💡 Pro Tips

1. **Always Hot Restart after changes** - Press `R` whenever you change configuration
2. **Check error messages** - If you still see "localhost", Hot Restart again
3. **Keep backend running** - Don't close the backend terminal window
4. **Same WiFi** - Ensure phone and computer are on the same network

---

## 🆘 Emergency Contact

If nothing works:
1. Show me the output of: `Get-Content lib\services\api_service.dart | Select-String "baseUrl"`
2. Show me the exact error message from Flutter console
3. Show me the output of: `curl http://172.16.140.134:5000`

**Remember**: The key is **Hot Restart (R)** after the app launches! 🔑
