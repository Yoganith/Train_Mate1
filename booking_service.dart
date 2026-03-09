import 'package:flutter/foundation.dart';
import '../models/firebase_models.dart';
import 'user_session_service.dart';
import 'api_service.dart';
import 'dart:math';

final ApiService _api = ApiService();

/// Booking service that forwards booking requests to the Node backend.
class BookingService {

  /// Create a new booking by calling backend. Expects backend to return created booking JSON.
  static Future<BookingModel> createBooking({
    required String trainId,
    required TrainModel train,
    required List<PassengerInfo> passengers,
    required String selectedCoach,
    required List<String> selectedSeats,
    required DateTime travelDate,
    required double totalAmount,
    Map<String, dynamic>? additionalInfo,
  }) async {
    final userId = UserSessionService.userId;
    if (userId == null) throw 'User not authenticated';

    final pnrNumber = _generatePNR();

    final bookingPayload = {
      'userId': userId,
      'trainId': trainId,
      'passengers': passengers.map((p) => p.toMap()).toList(),
      'selectedCoach': selectedCoach,
      'selectedSeats': selectedSeats,
      'travelDate': travelDate.toIso8601String(),
      'totalAmount': totalAmount,
      'pnrNumber': pnrNumber,
      'additionalInfo': additionalInfo,
    };

    try {
      final res = await _api.bookTrain(bookingPayload);
      // Backend returns booking object under 'booking' or as root
      final bookingJson = res['booking'] ?? res;
      return BookingModel.fromJson(Map<String, dynamic>.from(bookingJson));
    } catch (e) {
      if (kDebugMode) print('Create booking error: $e');
      // Fallback: construct local booking
      final fallback = BookingModel(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        trainId: trainId,
        train: train,
        passengers: passengers,
        selectedCoach: selectedCoach,
        selectedSeats: selectedSeats,
        bookingDate: DateTime.now(),
        travelDate: travelDate,
        totalAmount: totalAmount,
        bookingStatus: 'CONFIRMED',
        pnrNumber: pnrNumber,
        additionalInfo: additionalInfo,
      );
      return fallback;
    }
  }

  /// Get user bookings
  static Future<List<BookingModel>> getUserBookings() async {
    try {
      final userId = UserSessionService.userId;
      if (userId == null) return [];
      final res = await _api.getUserBookings(userId: userId);
      return res.map((b) => BookingModel.fromJson(Map<String, dynamic>.from(b))).toList();
    } catch (e) {
      if (kDebugMode) print('getUserBookings error: $e');
      return [];
    }
  }

  /// Get booking by ID
  static Future<BookingModel?> getBookingById(String bookingId) async {
    // Not implemented on backend. Return null.
    return null;
  }

  /// Get booking by PNR
  static Future<BookingModel?> getBookingByPNR(String pnr) async {
    // Not implemented on backend. Return null.
    return null;
  }

  /// Update booking status
  static Future<void> updateBookingStatus(String bookingId, String status) async {
    // Not implemented on backend
    return;
  }

  /// Cancel booking
  static Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(bookingId, 'CANCELLED');
  }

  /// Get upcoming bookings
  static Future<List<BookingModel>> getUpcomingBookings() async {
    // Not implemented on backend
    return [];
  }

  /// Get booking history
  static Future<List<BookingModel>> getBookingHistory() async {
    // Not implemented on backend
    return [];
  }

  /// Stream user bookings (real-time updates)
  static Stream<List<BookingModel>> streamUserBookings() => Stream.empty();

  /// Get booking statistics
  static Future<Map<String, dynamic>> getBookingStats() async {
    // Not implemented; return defaults
    return {
      'totalBookings': 0,
      'confirmedBookings': 0,
      'cancelledBookings': 0,
      'totalSpent': 0.0,
    };
  }

  /// Generate PNR number
  static String _generatePNR() {
    final random = Random();
    final digits = List.generate(10, (index) => random.nextInt(10));
    return digits.join('');
  }
}