import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔗 Base URL of your Node.js backend
  // IMPORTANT: When running on Android device/emulator, use your computer's IP address
  // To find your IP: Run 'ipconfig' (Windows) or 'ifconfig' (Mac/Linux)
  // Current setup: 172.16.140.134 is this computer's IP address
  // For Android emulator, you can also use 10.0.2.2 to reach host machine
  // For web testing, use http://localhost:5000
  final String baseUrl = "http://172.16.140.134:5000";

  // 🚆 Fetch all trains
  Future<List<dynamic>> getTrains() async {
    final response = await http.get(Uri.parse("$baseUrl/api/trains"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load trains");
    }
  }

  // 🔍 Search trains by source and destination
  Future<Map<String, dynamic>> searchTrains({
    required String from,
    required String to,
    String? date,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/api/trains/search").replace(
        queryParameters: {
          'from': from,
          'to': to,
          if (date != null) 'date': date,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Success: return trains
        return {
          'success': true,
          'trains': json.decode(response.body),
        };
      } else if (response.statusCode == 404) {
        // No trains found: return error with suggestions
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'No trains found',
          'suggestions': data['suggestions'],
        };
      } else {
        throw Exception("Failed to search trains: ${response.statusCode}");
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error searching trains: $e',
      };
    }
  }

  // 🧍 Register new user
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );
    return json.decode(response.body);
  }

  // 🔐 Login
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );
    return json.decode(response.body);
  }

  // 🎟️ Book train
  Future<Map<String, dynamic>> bookTrain(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/bookings"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(bookingData),
      );
      
      // Check if the response is valid JSON
      if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
        return json.decode(response.body);
      } else {
        // If not valid JSON, return an error message
        return {
          'status': 'error',
          'message': 'Invalid response from server',
          'details': response.body,
        };
      }
    } catch (e) {
      // Handle any errors during the API call
      return {
        'status': 'error',
        'message': 'Failed to connect to the server',
        'details': e.toString(),
      };
    }
  }

  // 📄 Get user bookings
  Future<List<dynamic>> getUserBookings({String? userId}) async {
    final uri = Uri.parse('$baseUrl/api/bookings${userId != null ? '?userId=$userId' : ''}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['bookings'] as List<dynamic>;
    }
    throw Exception('Failed to fetch bookings');
  }

  // 📄 Get booking by id
  Future<Map<String, dynamic>> getBookingById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/bookings/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch booking');
  }
}
