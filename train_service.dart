import 'package:flutter/foundation.dart';
import '../models/firebase_models.dart';
import 'user_session_service.dart';
import 'api_service.dart';

/// Service proxy that talks to the Node backend instead of Firestore
/// Uses ApiService to fetch train data as JSON and converts to TrainModel
final ApiService _api = ApiService();

/// Firebase Train Service for managing train data
class TrainService {
  /// Search trains by calling backend API and filtering locally
  static Future<List<TrainModel>> searchTrains({
    required String fromStation,
    required String toStation,
    required DateTime travelDate,
  }) async {
    try {
      final raw = await _api.getTrains();
      final trains = (raw as List)
          .map((e) => TrainModel.fromJson(Map<String, dynamic>.from(e)))
          .where((train) =>
              train.departureStation.toLowerCase().contains(fromStation.toLowerCase()) &&
              train.arrivalStation.toLowerCase().contains(toStation.toLowerCase()))
          .toList();

      // Best-effort: save search history to backend if endpoint exists
      try {
        final userId = UserSessionService.userId;
        if (userId != null) {
          // fire-and-forget: backend may expose a searchHistory endpoint later
        }
      } catch (_) {}

      return trains;
    } catch (e) {
      if (kDebugMode) print('Search trains error: $e');
      return _getDemoTrains(fromStation, toStation);
    }
  }

  /// Get train by ID
  static Future<TrainModel?> getTrainById(String trainId) async {
    try {
      final raw = await _api.getTrains();
      final trains = (raw as List)
          .map((e) => TrainModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final found = trains.where((t) => t.id == trainId).toList();
      return found.isNotEmpty ? found.first : null;
    } catch (e) {
      if (kDebugMode) print('Get train by ID error: $e');
      return null;
    }
  }

  /// Stream train availability (real-time updates)
  // Real-time streams are not supported by the simple Node backend.
  // Provide a periodic poller or WebSocket in future. For now, return an empty stream.
  static Stream<TrainModel> streamTrainAvailability(String trainId) => Stream.empty();

  /// Update train availability
  static Future<void> updateTrainAvailability(
    String trainId,
    String className,
    int availableSeats,
  ) async {
    // The Node backend currently doesn't expose a granular update endpoint for seats.
    // Implement this on the server and call it here; for now this is a no-op.
    if (kDebugMode) {
      print('updateTrainAvailability: no-op for train $trainId');
    }
  }

  /// Get popular routes
  static Future<List<Map<String, String>>> getPopularRoutes() async {
    // Backend does not expose search history analytics by default.
    // Return demo routes for now.
    return _getDemoRoutes();
  }

  /// Get user search history
  static Future<List<SearchHistoryModel>> getUserSearchHistory() async {
    // Not implemented on backend; return empty list for now
    return [];
  }

  // Search history persistence not implemented yet on backend
  /// Add/Update train in database
  /// Not implemented: backend needs endpoints to create/update trains.
  static Future<void> addOrUpdateTrain(TrainModel train) async {
    throw UnimplementedError('addOrUpdateTrain is not implemented on the backend');
  }

  /// Initialize demo train data
  static Future<void> initializeDemoTrains() async {
    try {
      final demoTrains = _getDemoTrains('New Delhi', 'Mumbai');
      
      for (final train in demoTrains) {
        await addOrUpdateTrain(train);
      }

      if (kDebugMode) {
        print('Demo trains initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Initialize demo trains error: $e');
      }
    }
  }

  /// Get demo trains for offline/demo purposes
  static List<TrainModel> _getDemoTrains(String fromStation, String toStation) {
    return [
      TrainModel(
        id: 'demo_train_1',
        trainNumber: '12951',
        trainName: 'Rajdhani Express',
        trainType: 'Superfast',
        departureStation: fromStation,
        arrivalStation: toStation,
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 16, minutes: 55)),
        arrivalTime: DateTime.now().add(const Duration(days: 2, hours: 8, minutes: 15)),
        classes: {
          'AC1': ClassInfo(
            className: 'AC 1 Tier',
            price: 3540.0,
            totalSeats: 24,
            availableSeats: 12,
            availability: 'CURR_AVBL',
            isTatkalAvailable: true,
          ),
          'AC2': ClassInfo(
            className: 'AC 2 Tier',
            price: 2330.0,
            totalSeats: 48,
            availableSeats: 25,
            availability: 'CURR_AVBL',
            isTatkalAvailable: true,
          ),
          'AC3': ClassInfo(
            className: 'AC 3 Tier',
            price: 1845.0,
            totalSeats: 72,
            availableSeats: 45,
            availability: 'CURR_AVBL',
            isTatkalAvailable: true,
          ),
        },
        runningDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        route: {
          'stations': [fromStation, 'Kanpur', 'Allahabad', 'Bhopal', toStation],
          'distances': [0, 441, 635, 1051, 1384],
        },
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      TrainModel(
        id: 'demo_train_2',
        trainNumber: '12953',
        trainName: 'August Kranti Rajdhani',
        trainType: 'Superfast',
        departureStation: fromStation,
        arrivalStation: toStation,
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 17, minutes: 20)),
        arrivalTime: DateTime.now().add(const Duration(days: 2, hours: 9, minutes: 45)),
        classes: {
          'AC2': ClassInfo(
            className: 'AC 2 Tier',
            price: 2455.0,
            totalSeats: 48,
            availableSeats: 18,
            availability: 'CURR_AVBL',
            isTatkalAvailable: true,
          ),
          'AC3': ClassInfo(
            className: 'AC 3 Tier',
            price: 1965.0,
            totalSeats: 72,
            availableSeats: 32,
            availability: 'CURR_AVBL',
            isTatkalAvailable: false,
          ),
        },
        runningDays: ['Mon', 'Wed', 'Fri', 'Sun'],
        route: {
          'stations': [fromStation, 'Kota', 'Ratlam', 'Vadodara', toStation],
          'distances': [0, 465, 718, 1028, 1384],
        },
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  /// Get demo popular routes
  static List<Map<String, String>> _getDemoRoutes() {
    return [
      {'from': 'New Delhi', 'to': 'Mumbai', 'count': '150'},
      {'from': 'Delhi', 'to': 'Bangalore', 'count': '120'},
      {'from': 'Mumbai', 'to': 'Chennai', 'count': '98'},
      {'from': 'Kolkata', 'to': 'Delhi', 'count': '87'},
      {'from': 'Chennai', 'to': 'Hyderabad', 'count': '76'},
    ];
  }
}