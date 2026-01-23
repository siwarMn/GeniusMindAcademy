class Flashcard {
  final int id;
  final String front;
  final String back;
  final String category;
  final bool memorized;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.category,
    required this.memorized,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      front: json['front'] ?? '',
      back: json['back'] ?? '',
      category: json['category'] ?? '',
      memorized: json['memorized'] ?? false,
    );
  }
}
