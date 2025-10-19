import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// Auth Service
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth State Stream
final authStateProvider = StreamProvider<Session?>((ref) {
  final supabase = Supabase.instance.client;
  return supabase.auth.onAuthStateChange.map((event) => event.session);
});

// Current session
final sessionProvider = Provider<Session?>((ref) {
  return ref.watch(authStateProvider).maybeWhen(
    data: (session) => session,
    orElse: () => null,
  );
});

// Current user
final currentUserProvider = Provider<User?>((ref) {
  final session = ref.watch(sessionProvider);
  return session?.user;
});

/// ------------------
/// Forgot Password Flow
/// ------------------

// Step 1: send reset email
final forgotPasswordProvider = FutureProvider.family<String?, String>((ref, email) async {
  final authService = ref.read(authServiceProvider);
  return await authService.resetPassword(email);
});

// Reset password provider (updates password after token verification)
final resetPasswordProvider = FutureProvider.family<String?, String>((ref, newPassword) async {
  final authService = ref.read(authServiceProvider);
  return await authService.updatePassword(newPassword);
});

