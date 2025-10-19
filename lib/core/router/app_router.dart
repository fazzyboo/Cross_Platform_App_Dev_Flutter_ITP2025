import 'package:ecommerce_app/screens/forgot_password_screen.dart';
import 'package:ecommerce_app/screens/otp_verification_screen.dart';
import 'package:ecommerce_app/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/change_password_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final email = state.extra as String;
          return OtpVerificationScreen(email: email);
        },
      ),

      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) {
          // Extract access_token from query parameters or URI fragment
          // final accessToken = state.uri.queryParameters['access_token'] ??
          //     state.uri.fragment.split('access_token=').lastWhere(
          //           (s) => s.startsWith('access_token=') || s.contains('&'),
          //       orElse: () => '',
          //     ).split('&').first.replaceAll('access_token=', '') ;

          return ChangePasswordScreen();
        },
      ),
    ],
    // Handle deep link redirects
    redirect: (context, state) {
      // If the path contains a hash fragment with tokens, parse it
      final uri = state.uri;
      if (uri.fragment.contains('access_token')) {
        // Extract token from fragment
        final fragment = uri.fragment;
        final params = Uri.splitQueryString(fragment);
        final accessToken = params['access_token'] ?? '';
        final type = params['type'] ?? '';

        // If it's a password recovery, redirect to change password
        if (type == 'recovery' && accessToken.isNotEmpty) {
          return '/change-password?access_token=$accessToken';
        }
      }
      return null; // No redirect needed
    },
  );
});