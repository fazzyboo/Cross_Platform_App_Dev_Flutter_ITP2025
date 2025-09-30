import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class IdCardWidget extends StatefulWidget {
  const IdCardWidget({super.key});

  @override
  State<IdCardWidget> createState() => _IdCardWidgetState();
}

class _IdCardWidgetState extends State<IdCardWidget> {
  Color _cardBackgroundColor = Colors.white;
  Color _accentColor = const Color(0xFF1B5E20); // Dark green color
  String _currentFontFamily = 'Roboto';

  final List<String> _fontFamilies = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Oswald',
    'Playfair Display',
    'Merriweather',
    'Dancing Script',
    'Pacifico',
    'Indie Flower',
  ];

  void _changeColorsAndFont() {
    setState(() {
      /*_cardBackgroundColor = Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      );
      _accentColor = Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      );*/
      _currentFontFamily = _fontFamilies[Random().nextInt(_fontFamilies.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardBackgroundColor,
      body: Center(
        child: Container(
          width: 350, // Approximate width of an ID card
          height: 550, // Approximate height of an ID card
          decoration: BoxDecoration(
            color: _cardBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              // Top green section
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image.asset(
                          'assets/images/iut.png',
                          height: 60,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                          style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Student Photo
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.blueGrey[50], // Placeholder background
                  ),
                  child: Image.asset(
                    'assets/images/Faiyaz-Abrar.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Student ID
              _buildInfoRow(
                icon: Icons.credit_card,
                label: 'Student ID',
                value: '210041214',
                isId: true,
              ),
              const SizedBox(height: 10),
              // Student Name
              _buildInfoRow(
                icon: Icons.person,
                label: 'Student Name',
                value: 'Faiyaz Abrar',
              ),
              const SizedBox(height: 10),
              // Program
              _buildInfoRow(
                icon: Icons.school,
                label: 'Program',
                value: 'B.Sc. in CSE',
              ),
              const SizedBox(height: 10),
              // Department
              _buildInfoRow(
                icon: Icons.business,
                label: 'Department',
                value: 'CSE',
              ),
              const SizedBox(height: 10),
              // Location
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Location',
                value: 'Bangladesh',
              ),
              const Spacer(),
              // Bottom green section
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'A subsidiary organ of OIC',
                  style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeColorsAndFont,
        tooltip: 'Change Colors and Font',
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isId = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.getFont(_currentFontFamily).copyWith(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          if (isId)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4), // Light blue for ID background
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                value,
                style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
}
}
