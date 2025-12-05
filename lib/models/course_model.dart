class CourseComment {
  final String author;
  final String text;
  final DateTime date;

  CourseComment({
    required this.author,
    required this.text,
    required this.date,
  });
}

class Course {
  final String id;
  final String title;
  final String description;
  final String imageAsset;
  final String pdfUrl; // Could be local asset path or remote URL
  final List<CourseComment> comments;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.pdfUrl,
    this.comments = const [],
  });
}
