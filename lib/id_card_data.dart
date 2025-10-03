import 'dart:typed_data';

class IdCardData {
  final String studentId;
  final String studentName;
  final String program;
  final String department;
  final String location;
  final Uint8List? studentPhotoBytes; 

  const IdCardData({
    required this.studentId,
    required this.studentName,
    required this.program,
    required this.department,
    required this.location,
    this.studentPhotoBytes,
  });
}
