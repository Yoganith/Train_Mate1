# Booking System Updates - RailBuddy

## Overview
This document outlines all the changes made to implement a comprehensive booking system with gender-based seat selection and MongoDB integration.

## Changes Made

### 1. ✅ Drawer Menu Updates
**File**: `lib/widgets/modern_drawer.dart`

**Removed Items**:
- Train List
- Berth Selection  
- Order Food

**Remaining Menu Items**:
- Search Trains
- Transactions
- PNR Enquiry
- My Account
- Settings
- Logout

---

### 2. ✅ Fixed Syntax Errors
**File**: `lib/screens/berth_selection_screen.dart`

**Fixed Issues**:
- Added missing closing brackets at line 260 (Column children)
- Fixed bracket mismatch in the widget tree structure
- Ensured proper nesting of Stack and Column widgets

---

### 3. ✅ MongoDB Booking Model Enhancement
**File**: `backend/models/Booking.js`

**Added Fields**:
```javascript
{
  // Existing fields
  userId: ObjectId (ref: User)
  trainId: ObjectId (ref: Train)
  seats: Number
  date: String
  
  // NEW FIELDS
  trainNumber: String
  trainName: String
  passengers: Array<PassengerSchema>
  from: String
  to: String
  departure: String
  arrival: String
  fare: String
  genderPreference: Enum ['Male', 'Female', 'Other', 'Any']
  bookingStatus: Enum ['Confirmed', 'Pending', 'Cancelled']
  pnr: String (unique)
  createdAt: Date
  updatedAt: Date
}
```

**Passenger Schema**:
```javascript
{
  name: String (required)
  age: Number (required)
  gender: Enum ['Male', 'Female', 'Other'] (required)
  seatNumber: String (required)
  coach: String (required)
  berthType: String (required) // LB, MB, UB, SL, SU
}
```

---

### 4. ✅ Gender-Based Seat Display
**File**: `lib/screens/berth_selection_screen.dart`

**Enhancement**: Booked seats now display gender-specific icons:
- 👨 **Blue Male Icon** - for male passengers
- 👩 **Pink Female Icon** - for female passengers  
- 👤 **Grey Person Icon** - for other/unspecified gender

**Implementation**:
```dart
// Booked seat displays gender icon + "B" label
Column(
  children: [
    Icon(
      gender == 'Male' ? Icons.male : 
      gender == 'Female' ? Icons.female : Icons.person,
      color: gender == 'Male' ? Colors.blue : 
             gender == 'Female' ? Colors.pink : Colors.grey,
      size: 18,
    ),
    Text('B', style: bold red text)
  ]
)
```

---

### 5. ✅ Backend API Routes
**File**: `backend/routes/booking.js`

**New/Updated Endpoints**:

#### POST `/api/bookings`
Create a new booking with complete passenger details
```json
Request Body:
{
  "userId": "string",
  "trainId": "string",
  "trainNumber": "string",
  "trainName": "string",
  "passengers": [
    {
      "name": "string",
      "age": number,
      "gender": "Male|Female|Other",
      "seatNumber": "string",
      "coach": "string",
      "berthType": "string"
    }
  ],
  "seats": number,
  "date": "string",
  "from": "string",
  "to": "string",
  "departure": "string",
  "arrival": "string",
  "fare": "string",
  "genderPreference": "Male|Female|Other|Any"
}

Response:
{
  "message": "Booking confirmed successfully",
  "booking": {...},
  "pnr": "PNR123456789"
}
```

#### GET `/api/bookings/user/:userId`
Get all bookings for a specific user (sorted by creation date)

#### GET `/api/bookings/pnr/:pnr`
Retrieve booking details by PNR number

#### GET `/api/bookings/:id`
Get booking by MongoDB ID

#### PATCH `/api/bookings/:id/cancel`
Cancel a booking and restore seat availability

#### GET `/api/bookings/seats/:trainId/:coach/:date`
Get seat occupancy with gender information for a specific train/coach/date
```json
Response:
{
  "occupiedSeats": [
    {
      "seatNumber": "S1-5",
      "gender": "Male",
      "berthType": "LB"
    }
  ]
}
```

---

## Database Schema

### MongoDB Collections

#### 1. **bookings** Collection
```javascript
{
  _id: ObjectId,
  userId: ObjectId,
  trainId: ObjectId,
  trainNumber: "12951",
  trainName: "Rajdhani Express",
  passengers: [
    {
      name: "John Doe",
      age: 30,
      gender: "Male",
      seatNumber: "S1-24",
      coach: "S1",
      berthType: "LB"
    }
  ],
  seats: 1,
  date: "2025-11-15",
  from: "Delhi",
  to: "Mumbai",
  departure: "16:55",
  arrival: "08:15",
  fare: "₹1,845",
  genderPreference: "Male",
  bookingStatus: "Confirmed",
  pnr: "PNR1234567890",
  createdAt: ISODate("2025-10-21T15:30:00Z"),
  updatedAt: ISODate("2025-10-21T15:30:00Z")
}
```

---

## Integration Guide

### Frontend (Flutter) Integration

1. **Update API Service** to use new booking endpoints:
```dart
// In api_service.dart
Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/bookings'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  return jsonDecode(response.body);
}
```

2. **Update Berth Selection Screen** to pass passenger data:
```dart
// When confirming seat selection
Navigator.pushNamed(
  context,
  '/passenger-details',
  arguments: {
    'train': trainData,
    'selectedSeat': selectedSeat,
    'selectedCoach': selectedCoach,
    'genderPreference': selectedGender,
    'fare': fare,
  },
);
```

3. **Passenger Details Screen** should collect:
- Passenger name
- Age
- Gender (Male/Female/Other)
- And submit with seat/coach info to backend

---

## Testing

### Backend Testing with Postman/cURL

1. **Create Booking**:
```bash
curl -X POST http://localhost:5000/api/bookings \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user123",
    "trainId": "train456",
    "trainNumber": "12951",
    "trainName": "Rajdhani Express",
    "passengers": [
      {
        "name": "John Doe",
        "age": 30,
        "gender": "Male",
        "seatNumber": "S1-24",
        "coach": "S1",
        "berthType": "LB"
      }
    ],
    "seats": 1,
    "date": "2025-11-15",
    "from": "Delhi",
    "to": "Mumbai",
    "departure": "16:55",
    "arrival": "08:15",
    "fare": "₹1,845",
    "genderPreference": "Male"
  }'
```

2. **Get User Bookings**:
```bash
curl http://localhost:5000/api/bookings/user/user123
```

3. **Get Booking by PNR**:
```bash
curl http://localhost:5000/api/bookings/pnr/PNR1234567890
```

4. **Get Seat Occupancy**:
```bash
curl http://localhost:5000/api/bookings/seats/train456/S1/2025-11-15
```

---

## MongoDB Compass Usage

### Viewing Data

1. Open **MongoDB Compass**
2. Connect to your MongoDB instance (usually `mongodb://localhost:27017`)
3. Navigate to your database (e.g., `trainBookingDB`)
4. Collections to check:
   - `bookings` - All booking records with passenger details
   - `users` - User information
   - `trains` - Train data

### Sample Queries

**Find all confirmed bookings**:
```javascript
{ bookingStatus: "Confirmed" }
```

**Find bookings by gender preference**:
```javascript
{ genderPreference: "Female" }
```

**Find bookings with male passengers**:
```javascript
{ "passengers.gender": "Male" }
```

**Find bookings by PNR**:
```javascript
{ pnr: "PNR1234567890" }
```

---

## Features Implemented

✅ **Gender-based seat selection**
- Users can filter seats by gender preference
- Visual indicators show gender of booked seats
- Privacy warnings for mixed-gender compartments

✅ **Complete passenger information storage**
- Name, age, gender stored for each passenger
- Seat number and coach information preserved
- Berth type (LB, MB, UB, SL, SU) tracked

✅ **PNR generation**
- Unique 10-digit PNR for each booking
- Format: `PNR` + timestamp(6) + random(4)

✅ **Booking management**
- Create, retrieve, cancel bookings
- Automatic seat availability updates
- Booking status tracking

✅ **Data persistence**
- All booking data stored in MongoDB
- Retrievable via multiple query methods (ID, PNR, user)
- Seat occupancy tracking per train/coach/date

---

## Next Steps

1. **Add authentication middleware** to secure booking endpoints
2. **Implement payment integration** before confirming bookings
3. **Add email/SMS notifications** with PNR details
4. **Create admin dashboard** to view all bookings
5. **Add booking analytics** (revenue, popular routes, etc.)
6. **Implement seat lock mechanism** during booking process

---

## Support

For issues or questions:
- Check MongoDB connection: `backend/config/db.js`
- Verify backend is running: `http://localhost:5000/api/bookings/health`
- Check Flutter API service configuration
- Review console logs for detailed error messages

---

**Last Updated**: October 21, 2025  
**Version**: 3.0
