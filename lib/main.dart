import 'package:flutter/material.dart';
import 'id_card_widget.dart';
import 'id_card_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const IdCardData myIdCardData = IdCardData(
      studentId: '210041214',
      studentName: 'FAIYAZ ABRAR',
      program: 'B.Sc. in CSE',
      department: 'CSE',
      location: 'Bangladesh',
      studentPhotoBytes: null, 
    );

    return MaterialApp(
      title: 'ID Card Replica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const IdCardWidget(cardData: myIdCardData),
    );
  }
}
