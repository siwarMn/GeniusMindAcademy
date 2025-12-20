// Comment Response DTO
class CommentResponse {
  final int? id;
  final String author;
  final String text;
  final DateTime date;

  CommentResponse({
    this.id,
    required this.author,
    required this.text,
    required this.date,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'],
      author: json['author'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}

// Reclamation Response DTO
class ReclamationResponse {
  final int? id;
  final String titre;
  final String categorie;
  final String description;
  final String creerpar;
  final String status;
  final DateTime? createdAt;
  final List<CommentResponse> comments;

  ReclamationResponse({
    this.id,
    required this.titre,
    required this.categorie,
    required this.description,
    required this.creerpar,
    required this.status,
    this.createdAt,
    this.comments = const [],
  });

  factory ReclamationResponse.fromJson(Map<String, dynamic> json) {
    List<CommentResponse> commentsList = [];
    if (json['comments'] != null) {
      commentsList = (json['comments'] as List)
          .map((c) => CommentResponse.fromJson(c))
          .toList();
    }

    return ReclamationResponse(
      id: json['id'],
      titre: json['titre'] ?? '',
      categorie: json['categorie'] ?? '',
      description: json['description'] ?? '',
      creerpar: json['creerpar'] ?? '',
      status: json['status'] ?? 'Open',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      comments: commentsList,
    );
  }
}

// Reclamation Request DTO
class ReclamationRequest {
  final String titre;
  final String categorie;
  final String description;
  final String creerpar;

  ReclamationRequest({
    required this.titre,
    required this.categorie,
    required this.description,
    required this.creerpar,
  });

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'categorie': categorie,
      'description': description,
      'creerpar': creerpar,
    };
  }
}

// Comment Request DTO
class CommentRequest {
  final String author;
  final String text;

  CommentRequest({
    required this.author,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'text': text,
    };
  }
}

// Status Update Request DTO
class StatusUpdateRequest {
  final String status;

  StatusUpdateRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
