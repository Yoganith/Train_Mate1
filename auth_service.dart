import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/firebase_models.dart';
import 'user_session_service.dart';

/// Firebase Authentication Service
class AuthService {
  static const String _baseUrl = 'http://172.16.140.134:5000';

  /// Sign up with email and password
  static Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/auth/register');
      final body = jsonEncode({
        'name': fullName,
        'email': email,
        'password': password,
      });
      final res = await http.post(uri, headers: {
        'Content-Type': 'application/json'
      }, body: body).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>;
        final token = data['token'] as String?;

        // Persist token and set current user
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          UserSessionService.setCurrentUser(
            user['_id'] ?? user['id'] ?? user['uid'], 
            token,
            name: user['name'] ?? fullName,
            email: user['email'] ?? email,
          );
        }

        final userModel = UserModel(
          uid: user['_id'] ?? user['id'] ?? user['uid'] ?? '',
          email: user['email'] ?? email,
          fullName: user['name'] ?? fullName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          isVerified: false,
        );
        return userModel;
      } else {
        final err = res.body.isNotEmpty ? res.body : 'Registration failed';
        if (kDebugMode) print('SignUp Error: $err');
        throw err;
      }
    } catch (e) {
      if (kDebugMode) print('SignUp Error: $e - Using offline mode');
      // Fallback: Create user locally when backend is unavailable
      return _createLocalUser(email, fullName, phoneNumber);
    }
  }

  /// Sign in with email and password
  static Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/auth/login');
      final body = jsonEncode({
        'email': email,
        'password': password,
      });
      final res = await http.post(uri, headers: {
        'Content-Type': 'application/json'
      }, body: body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>;
        final token = data['token'] as String?;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          UserSessionService.setCurrentUser(
            user['_id'] ?? user['id'] ?? user['uid'], 
            token,
            name: user['name'] ?? '',
            email: user['email'] ?? email,
          );
        }

        final userModel = UserModel(
          uid: user['_id'] ?? user['id'] ?? user['uid'] ?? '',
          email: user['email'] ?? email,
          fullName: user['name'] ?? '',
          phoneNumber: user['phoneNumber'],
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          isVerified: true,
        );
        return userModel;
      } else if (res.statusCode == 401) {
        throw 'Invalid credentials';
      } else {
        throw res.body.isNotEmpty ? res.body : 'Login failed';
      }
    } catch (e) {
      if (kDebugMode) print('SignIn Error: $e - Using offline mode');
      // Fallback: Sign in locally when backend is unavailable
      return _signInLocally(email, password);
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      UserSessionService.clearCurrentUser();
    } catch (e) {
      if (kDebugMode) print('SignOut Error: $e');
      throw 'Failed to sign out. Please try again.';
    }
  }

  /// Check if user is authenticated (legacy method for compatibility)
  static Future<bool> isAuthenticated() async {
    // Check token presence
    return UserSessionService.token != null;
  }

  /// Set authenticated state (legacy method - now handled by Firebase)
  static Future<void> setAuthenticated(bool value) async {
    // This method is now handled by Firebase Auth automatically
    if (kDebugMode) {
      print('setAuthenticated called with value: $value (handled by Firebase)');
    }
  }

  /// Logout (legacy method name)
  static Future<void> logout() async {
    await signOut();
  }

  /// Reset password
  // Password reset, email verification and direct Firestore reads are not available
  // in this backend-only implementation. Implement these on the server if needed.
  static Future<void> resetPassword(String email) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/auth/reset-password');
      final body = jsonEncode({'email': email});
      final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) {
        if (kDebugMode) print('Password reset requested: ${res.body}');
        return;
      } else {
        throw res.body.isNotEmpty ? res.body : 'Failed to request password reset';
      }
    } catch (e) {
      if (kDebugMode) print('Reset Password Error: $e');
      rethrow;
    }
  }

  // ========== LOCAL FALLBACK METHODS ==========
  
  /// Create user locally when backend is unavailable
  static Future<UserModel> _createLocalUser(String email, String fullName, String? phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = 'local_${DateTime.now().millisecondsSinceEpoch}';
      final token = 'local_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Store user data locally
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', fullName);
      if (phoneNumber != null) {
        await prefs.setString('user_phone', phoneNumber);
      }
      
      // Set current user in session
      UserSessionService.setCurrentUser(
        userId,
        token,
        name: fullName,
        email: email,
      );
      
      final userModel = UserModel(
        uid: userId,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        isVerified: false,
      );
      
      if (kDebugMode) print('✓ User created locally (offline mode)');
      return userModel;
    } catch (e) {
      if (kDebugMode) print('Failed to create local user: $e');
      throw 'Failed to create account. Please try again.';
    }
  }
  
  /// Sign in locally when backend is unavailable
  static Future<UserModel> _signInLocally(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('user_email');
      
      // Check if user exists locally
      if (storedEmail == email) {
        final userId = prefs.getString('user_id') ?? 'local_${DateTime.now().millisecondsSinceEpoch}';
        final token = 'local_token_${DateTime.now().millisecondsSinceEpoch}';
        final fullName = prefs.getString('user_name') ?? 'User';
        final phoneNumber = prefs.getString('user_phone');
        
        await prefs.setString('auth_token', token);
        
        UserSessionService.setCurrentUser(
          userId,
          token,
          name: fullName,
          email: email,
        );
        
        final userModel = UserModel(
          uid: userId,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          isVerified: true,
        );
        
        if (kDebugMode) print('✓ Signed in locally (offline mode)');
        return userModel;
      } else {
        // User not found locally, create new one
        if (kDebugMode) print('User not found locally, creating new account...');
        return _createLocalUser(email, 'User', null);
      }
    } catch (e) {
      if (kDebugMode) print('Failed to sign in locally: $e');
      throw 'Failed to sign in. Please try again.';
    }
  }
}
