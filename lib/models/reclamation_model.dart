class ReclamationComment {
  final String author;
  final String text;
  final DateTime date;

  ReclamationComment({
    required this.author,
    required this.text,
    required this.date,
  });
}

class Reclamation {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // 'Open', 'In Progress', 'Resolved'
  final DateTime createdAt;
  final List<ReclamationComment> comments;

  Reclamation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.comments = const [],
  });
}
