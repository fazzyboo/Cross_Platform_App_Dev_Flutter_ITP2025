import 'package:flutter/material.dart';
import 'package:flutter_application_1/id_card_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Import for Uint8List

class IdCardFormPage extends StatefulWidget {
  const IdCardFormPage({super.key});

  @override
  State<IdCardFormPage> createState() => _IdCardFormPageState();
}

class _IdCardFormPageState extends State<IdCardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _programController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _programController.dispose();
    _departmentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _generateCard() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        '/idCard',
        arguments: IdCardData(
          studentId: _studentIdController.text,
          studentName: _studentNameController.text,
          program: _programController.text,
          department: _departmentController.text,
          location: _locationController.text,
          studentPhotoBytes: _selectedImageBytes,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate ID Card'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SizedBox(
          width: 400, // Standard phone width
          height: 700, // Standard phone height
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Increased padding for the card content
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0), // Padding below the image picker
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: _selectedImageBytes != null
                              ? Image.memory(
                                  _selectedImageBytes!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                        ),
                      ),
                    ),
                    _buildTextField(
                      controller: _studentIdController,
                      labelText: 'Student ID',
                      icon: Icons.credit_card,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    _buildTextField(
                      controller: _studentNameController,
                      labelText: 'Student Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    _buildTextField(
                      controller: _programController,
                      labelText: 'Program',
                      icon: Icons.school,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    _buildTextField(
                      controller: _departmentController,
                      labelText: 'Department',
                      icon: Icons.business,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    _buildTextField(
                      controller: _locationController,
                      labelText: 'Location',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 40), // Increased spacing before button
                    ElevatedButton(
                      onPressed: _generateCard,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Generate Card'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}

class IdCardData {
  final String studentId;
  final String studentName;
  final String program;
  final String department;
  final String location;
  final Uint8List? studentPhotoBytes;

  IdCardData({
    required this.studentId,
    required this.studentName,
    required this.program,
    required this.department,
    required this.location,
    this.studentPhotoBytes,
  });
}
