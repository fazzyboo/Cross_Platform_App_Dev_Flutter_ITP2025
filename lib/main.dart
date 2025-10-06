import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest_api_call/router/app_router.dart';
import 'package:rest_api_call/services/local_database_service.dart';
import 'package:rest_api_call/news_provider.dart'; // Import news_provider to access localDatabaseServiceProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localDatabaseService = LocalDatabaseService();
  await localDatabaseService.init(); // Initialize the database service

  runApp(
    ProviderScope(
      overrides: [
        localDatabaseServiceProvider.overrideWithValue(localDatabaseService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hacker News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}
