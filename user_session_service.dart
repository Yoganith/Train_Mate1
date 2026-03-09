import 'package:flutter/foundation.dart';

/// Lightweight service that holds user session info (user id + token from backend).
class UserSessionService {
  static String? _userId;
  static String? _token;
  static String? _userName;
  static String? _userEmail;
  static int bookingCount = 0;

  static void setCurrentUser(String? userId, String? token, {String? name, String? email}) {
    _userId = userId;
    _token = token;
    _userName = name;
    _userEmail = email;
    if (kDebugMode) print('Current user set: $_userId');
  }

  static void clearCurrentUser() {
    _userId = null;
    _token = null;
    _userName = null;
    _userEmail = null;
    bookingCount = 0;
    if (kDebugMode) print('Current user cleared');
  }

  static String? get userId => _userId;
  static String? get token => _token;
  static String get userName => _userName ?? 'Guest User';
  static String get userEmail => _userEmail ?? 'Not logged in';

  /// Convenience boolean used by legacy screens
  static bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  static Future<void> initialize() async {
    if (kDebugMode) print('User session service initialized');
  }
}
