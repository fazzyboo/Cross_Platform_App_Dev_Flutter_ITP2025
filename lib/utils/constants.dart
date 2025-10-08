import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader = Center(child: CircularProgressIndicator());

/// Simple error message inside a Center widget
const errorMessage = Center(child: Text('Something went wrong'));

/// Set of extension methods to show a snackbar
extension ShowSnackBar on BuildContext {
  void showSnackBar(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

/// Basic page padding
const pagePadding = EdgeInsets.all(8.0);
