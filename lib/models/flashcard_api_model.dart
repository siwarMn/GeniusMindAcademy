class FlashcardApiModel {
  final int id;
  final String front;
  final String back;
  final String category;
  final bool memorized;

  FlashcardApiModel({
    required this.id,
    required this.front,
    required this.back,
    required this.category,
    required this.memorized,
  });

  factory FlashcardApiModel.fromJson(Map<String, dynamic> json) {
    return FlashcardApiModel(
      id: json['id'],
      front: json['front'],
      back: json['back'],
      category: json['category'],
      memorized: json['memorized'] ?? false,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'front': front,
        'back': back,
        'category': category,
        'memorized': memorized,
      };

  Map<String, dynamic> toUpdateJson() => toCreateJson();
}
