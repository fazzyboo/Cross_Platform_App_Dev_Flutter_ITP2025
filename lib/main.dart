import 'package:flutter/material.dart';
import 'package:flutter_application_1/id_card_widget.dart';
import 'package:flutter_application_1/id_card_form_page.dart'; // Import IdCardFormPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card Replica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IdCardFormPage(),
        '/idCard': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as IdCardData;
          return IdCardWidget(cardData: args);
        },
      },
    );
  }
}
