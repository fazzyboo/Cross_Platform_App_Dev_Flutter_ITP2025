import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/id_card_form_page.dart'; // Import the data model
import 'dart:typed_data'; // Import for Uint8List

class IdCardWidget extends StatefulWidget {
  final IdCardData cardData;

  const IdCardWidget({super.key, required this.cardData});

  @override
  State<IdCardWidget> createState() => _IdCardWidgetState();
}

class _IdCardWidgetState extends State<IdCardWidget> {
  Color _cardBackgroundColor = const Color(0xFFF0F0F0); // Light grey background
  Color _accentColor = const Color(0xFF1A5220); // Darker green color
  String _currentFontFamily = 'Roboto';

  @override
  Widget build(BuildContext context) {
    const double photoHeight = 170;
    const double photoWidth = 140;
    // Height of the green section to cover half of the photo's background
    const double topGreenSectionHeight = 120 + (photoHeight / 2);

    return Scaffold(
      backgroundColor: _cardBackgroundColor,
      body: Center(
        child: Container(
          width: 380,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top green section
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: topGreenSectionHeight,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Center content vertically
                    children: [
                      SizedBox(height: 15),
                      Image.asset(
                        'assets/images/iut.png',
                        height: 70,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                        style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Student Photo
              Positioned(
                top: topGreenSectionHeight - (photoHeight / 2), // Position to overlap half
                left: (380 - photoWidth) / 2, // Center horizontally
                child: Container(
                  width: photoWidth,
                  height: photoHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: _accentColor, width: 6), // Dark green, thicker border
                    color: Colors.white,
                  ),
                  child: widget.cardData.studentPhotoBytes != null
                      ? Image.memory(
                          widget.cardData.studentPhotoBytes!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/Faiyaz-Abrar.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // Information Rows
              Positioned(
                top: topGreenSectionHeight + (photoHeight / 2) + 20, // Below the photo, with some spacing
                left: 100,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Center the column itself
                  children: [
                    _buildInfoRow(
                      icon: Icons.vpn_key,
                      label: 'Student ID',
                      value: widget.cardData.studentId,
                      isId: true,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Student Name',
                      value: widget.cardData.studentName,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      icon: Icons.school,
                      label: 'Program',
                      value: widget.cardData.program,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      icon: Icons.apartment,
                      label: 'Department',
                      value: widget.cardData.department,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      label: '', // Removed label
                      value: widget.cardData.location,
                    ),
                  ],
                ),
              ),
              // Bottom green section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: const Text('Go Back to Form'),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Go Back to Form',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isId = false,
  }) {
    final bool isStacked = (label == 'Student ID' || label == 'Student Name');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left-align content within this column
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // Left-align icon and label
            children: [
              Icon(icon, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              if (label.isNotEmpty) // Only show label if not empty (for Location)
                Text(
                  label,
                  style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              if (!isStacked && label.isNotEmpty) // Add space if not stacked and label is present
                const SizedBox(width: 4),
              if (!isStacked) // Display value on same line for Program, Department, Location
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
          if (isStacked) // Display value on new line for Student ID and Student Name
            isId
                ? Padding( // Apply padding specifically for Student ID
                    padding: const EdgeInsets.only(left: 0.0, top: 4.0), // Initial padding for ID
                    child: Container( // Special handling for Student ID pill
                      padding: const EdgeInsets.only(left: 10, right: 26, top: 6, bottom: 6), // Allows separate left/right padding
                      decoration: BoxDecoration(
                        color: _accentColor, // Changed to dark green accent color
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row( // Use Row to place circle and text side-by-side
                        mainAxisSize: MainAxisSize.min, // Wrap content
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 0, 119, 255), // Blue circle
                            ),
                          ),
                          const SizedBox(width: 8), // Spacing between circle and text
                          Text(
                            value,
                            style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding( // Apply padding specifically for Student Name
                    padding: const EdgeInsets.only(left: 20.0, top: 4.0), // Initial padding for Name
                    child: Text( // For Student Name
                      value,
                      style: GoogleFonts.getFont(_currentFontFamily).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
