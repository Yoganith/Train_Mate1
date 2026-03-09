# Train Search Feature - Setup & Usage Guide

## ✅ What's Been Updated

### 1. **Backend Updates**
- ✅ Enhanced `Train` model with more fields (departure, arrival, duration, fare, classes)
- ✅ Added `/api/trains/search` endpoint with case-insensitive location matching
- ✅ Created seed script with 16 real train routes across India

### 2. **Flutter Updates**
- ✅ Added `searchTrains()` method in `ApiService`
- ✅ Supports flexible location matching (partial, case-insensitive)

---

## 🚀 Quick Setup

### Step 1: Seed Train Data

```powershell
cd backend
node seed-trains.js
```

**Expected Output:**
```
✅ MongoDB connected
🗑️  Cleared existing train data
✅ Successfully seeded 16 trains

📊 Train Routes Summary:
   New Delhi → Mumbai Central
   New Delhi → Howrah
   New Delhi → Lucknow
   New Delhi → Bhopal
   ... (and more)

✅ Database seeding complete!
```

### Step 2: Verify in MongoDB Compass

1. Open MongoDB Compass
2. Connect to: `mongodb://localhost:27017`
3. Open `train_booking` database
4. Click on `trains` collection
5. You should see **16 trains** with full details

---

## 🔍 How Train Search Works

### **Flexible Location Matching**

The search is **case-insensitive** and supports **partial matches**:

| User Types | Matches |
|------------|---------|
| `delhi` | New **Delhi** |
| `DELHI` | New **Delhi** |
| `new delhi` | **New Delhi** |
| `mumbai` | **Mumbai** Central, **Mumbai** CST |
| `mumbai central` | **Mumbai Central** |
| `bangalore` | **Bangalore** |

### **Backend Search Logic**

```javascript
// Case-insensitive regex search
const query = {
  source: { $regex: new RegExp(from, 'i') },
  destination: { $regex: new RegExp(to, 'i') }
};
```

---

## 📡 API Usage

### **Search Endpoint**

```http
GET /api/trains/search?from=delhi&to=mumbai
```

**Query Parameters:**
- `from` (required) - Source location
- `to` (required) - Destination location
- `date` (optional) - Travel date

### **Success Response (200)**

```json
[
  {
    "_id": "...",
    "trainNo": "12951",
    "name": "Mumbai Rajdhani Express",
    "source": "New Delhi",
    "destination": "Mumbai Central",
    "departure": "16:55",
    "arrival": "08:35",
    "duration": "15h 40m",
    "fare": 1845,
    "seatsAvailable": 45,
    "classes": [
      {
        "type": "AC 1 Tier",
        "fare": 3540,
        "seatsAvailable": 12
      },
      {
        "type": "AC 2 Tier",
        "fare": 2330,
        "seatsAvailable": 18
      },
      {
        "type": "AC 3 Tier",
        "fare": 1845,
        "seatsAvailable": 32
      }
    ],
    "runningDays": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
  }
]
```

### **Not Found Response (404)**

```json
{
  "message": "No trains found from \"xyz\" to \"abc\"",
  "suggestions": {
    "fromThisSource": [
      {
        "to": "Mumbai Central",
        "trainName": "Mumbai Rajdhani Express"
      }
    ],
    "toThisDestination": [
      {
        "from": "Chennai Central",
        "trainName": "Grand Trunk Express"
      }
    ]
  }
}
```

---

## 💻 Flutter Integration

### **Using the Search API**

```dart
import 'package:train_booking_app/services/api_service.dart';

final apiService = ApiService();

// Search trains
final result = await apiService.searchTrains(
  from: 'Delhi',
  to: 'Mumbai',
  date: '2025-10-30', // optional
);

if (result['success'] == true) {
  // Trains found
  List<dynamic> trains = result['trains'];
  print('Found ${trains.length} trains');
  
  for (var train in trains) {
    print('${train['trainNo']} - ${train['name']}');
    print('Departure: ${train['departure']}');
    print('Fare: ₹${train['fare']}');
  }
} else {
  // No trains found
  print(result['message']);
  
  // Show suggestions if available
  if (result['suggestions'] != null) {
    print('Suggested routes:');
    print(result['suggestions']);
  }
}
```

---

## 🧪 Testing the Search

### **PowerShell Tests**

```powershell
# Test 1: Delhi to Mumbai
Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=delhi&to=mumbai"

# Test 2: Case insensitive
Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=NEW%20DELHI&to=MUMBAI"

# Test 3: Partial match
Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=del&to=mum"

# Test 4: Chennai to Delhi
Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=chennai&to=delhi"

# Test 5: No results (get suggestions)
Invoke-RestMethod -Uri "http://localhost:5000/api/trains/search?from=xyz&to=abc"
```

### **cURL Tests**

```bash
# Search Delhi to Mumbai
curl "http://localhost:5000/api/trains/search?from=delhi&to=mumbai"

# Search with date
curl "http://localhost:5000/api/trains/search?from=delhi&to=mumbai&date=2025-10-30"
```

---

## 🗺️ Available Routes (After Seeding)

The seed script includes these routes:

1. **New Delhi → Mumbai Central** (12951)
2. **New Delhi → Howrah** (12301)
3. **New Delhi → Lucknow** (12430)
4. **New Delhi → Bhopal** (12002)
5. **New Delhi → Chennai Central** (12622)
6. **Mumbai Central → New Delhi** (12259)
7. **Mumbai CST → Howrah** (12860)
8. **New Delhi → Trivandrum** (12626)
9. **New Delhi → Vasco Da Gama (Goa)** (12780)
10. **New Delhi → Amritsar** (12434)
11. **Chennai Central → New Delhi** (12616)
12. **New Delhi → Dibrugarh** (12423)
13. **Bangalore → New Delhi** (12650)
14. **Jodhpur → Howrah** (12308)
15. **Hyderabad → New Delhi** (12723)
16. **New Delhi → Bangalore** (22691)

---

## 🎯 Search Examples

### **Example 1: Exact Match**
```
User enters: "New Delhi" → "Mumbai Central"
Result: ✅ Mumbai Rajdhani Express (12951)
```

### **Example 2: Case Insensitive**
```
User enters: "new delhi" → "mumbai central"
Result: ✅ Mumbai Rajdhani Express (12951)
```

### **Example 3: Partial Match**
```
User enters: "Delhi" → "Mumbai"
Result: ✅ Mumbai Rajdhani Express (12951)
        ✅ Duronto Express (12259) - reverse route
```

### **Example 4: Short Form**
```
User enters: "del" → "mum"
Result: ✅ All trains with "del" in source and "mum" in destination
```

### **Example 5: Multiple Results**
```
User enters: "New Delhi" → (any destination)
Result: ✅ All 11 trains departing from New Delhi
```

---

## 🔧 Customization

### **Add More Trains**

Edit `backend/seed-trains.js` and add more train objects:

```javascript
{
  trainNo: "12345",
  name: "Your Train Name",
  source: "Source City",
  destination: "Destination City",
  departure: "HH:MM",
  arrival: "HH:MM",
  duration: "Xh Ym",
  fare: 1000,
  seatsAvailable: 50,
  totalSeats: 100,
  classes: [
    { type: "AC 3 Tier", fare: 1000, seatsAvailable: 50 }
  ],
  runningDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
}
```

Then run: `node seed-trains.js`

### **Change Search Logic**

Edit `backend/routes/trains.js`:

```javascript
// Current: Partial match
source: { $regex: new RegExp(from, 'i') }

// Option 1: Exact match
source: from

// Option 2: Starts with
source: { $regex: new RegExp(`^${from}`, 'i') }

// Option 3: Contains word
source: { $regex: new RegExp(`\\b${from}\\b`, 'i') }
```

---

## ✅ Verification Checklist

- [ ] Backend server is running
- [ ] MongoDB is running
- [ ] Trains seeded successfully (16 trains)
- [ ] Can see trains in MongoDB Compass
- [ ] Search API returns results
- [ ] Flutter app can call search endpoint
- [ ] Search works with different case inputs
- [ ] Search works with partial location names
- [ ] No trains found returns suggestions

---

## 🐛 Troubleshooting

### **"No trains found"**
- Run `node seed-trains.js` to populate data
- Check MongoDB Compass for `trains` collection
- Verify location names match (case-insensitive)

### **"Cannot GET /api/trains/search"**
- Check backend `routes/trains.js` has search route
- Restart backend server: `node server.js`

### **Empty response from API**
- Check backend console for errors
- Verify MongoDB connection is active
- Test with: `GET /api/trains` (should return all trains)

---

## 📚 Next Steps

1. **Run seed script**: `node backend/seed-trains.js`
2. **Test search**: Use PowerShell or cURL examples above
3. **Verify in Compass**: See 16 trains in database
4. **Update Flutter UI**: Use `searchTrains()` in your search screen
5. **Test from app**: Search for trains from different locations

---

**Your train search now supports flexible location matching!** 🎉

Users can type locations in any case, use partial names, and get accurate results.
