import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/auth/email_verification_page.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/auth/forgot_password_page.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/auth/login_page.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/auth/signup_page.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/main.dart'; // For HomePage
import 'package:cross_platform_app_dev_flutter_itp2025/account_page.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/utils/constants.dart'; // For supabase client

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordPage();
      },
    ),
    GoRoute(
      path: '/email-verification',
      builder: (BuildContext context, GoRouterState state) {
        return const EmailVerificationPage();
      },
    ),
    GoRoute(
      path: '/account',
      builder: (BuildContext context, GoRouterState state) {
        return const AccountPage();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = supabase.auth.currentUser != null;
    final bool loggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup' ||
        state.matchedLocation == '/forgot-password';

    // If not logged in, and not on a login/signup/forgot-password page, redirect to login
    if (!loggedIn && !loggingIn) {
      return '/login';
    }
    // If logged in, and on a login/signup/forgot-password page, redirect to home
    if (loggedIn && loggingIn) {
      return '/';
    }
    // No redirection needed
    return null;
  },
);
