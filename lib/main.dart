import 'package:flutter/material.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/chat_screen.dart';
import 'package:cross_platform_app_dev_flutter_itp2025/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial home
    );
  }
}
