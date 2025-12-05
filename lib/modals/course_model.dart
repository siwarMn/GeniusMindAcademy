// lib/models/course_model.dart
class CourseModel {
  final int? id;
  final String title;
  final String description;
  final String niveau;
  final String? pdfUrl;
  final String? videoUrl;
  final DateTime? createdAt;

  CourseModel({
    this.id,
    required this.title,
    required this.description,
    required this.niveau,
    this.pdfUrl,
    this.videoUrl,
    this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      niveau: json['niveau'] ?? '',
      pdfUrl: json['pdfUrl'],
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'niveau': niveau,
      'pdfUrl': pdfUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}