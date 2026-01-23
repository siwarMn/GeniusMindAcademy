// Course model - represents a file from the backend
// Backend returns: {id, fileName}
class Course {
  final int id;
  final String fileName;

  Course({
    required this.id,
    required this.fileName,
  });

  // Create a Course from backend JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      fileName: json['fileName'] ?? 'Untitled',
    );
  }
}
