import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Signup function
  Future<String?> signupwithEmailandPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) return null;
      return "An unknown error occurred";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error: $e";
    }
  }

  // Login function
  Future<String?> loginwithEmailandPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) return null;
      return "Invalid email or password";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error: $e";
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await _supabase.auth.signOut();
      if (!context.mounted) return;
      context.go('/login');
    } catch (e) {
      if (kDebugMode) print("Logout error: $e");
    }
  }

  // Step 1: send reset email with proper deep link
  Future<String?> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'http://localhost:5000/#/change-password', // For mobile deep linking
        // For web, Supabase will use your site URL configured in dashboard
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Step 2: update password after deep link opens app
  // This method assumes the user is already authenticated via the reset token
  Future<String?> updatePassword(String newPassword) async {
    try {
      final res = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (res.user != null) return null;
      return "Failed to update password";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Helper method to verify if user has a valid session
  bool isAuthenticated() {
    return _supabase.auth.currentSession != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}