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
  final String? priority;
  final String? assignedTo;
  final int? rating;
  final DateTime? createdAt;
  final List<CommentResponse> comments;

  ReclamationResponse({
    this.id,
    required this.titre,
    required this.categorie,
    required this.description,
    required this.creerpar,
    required this.status,
    this.priority,
    this.assignedTo,
    this.rating,
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
      priority: json['priority'],
      assignedTo: json['assignedTo'],
      rating: json['rating'],
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
  final String? priority;

  ReclamationRequest({
    required this.titre,
    required this.categorie,
    required this.description,
    required this.creerpar,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'categorie': categorie,
      'description': description,
      'creerpar': creerpar,
      'priority': priority,
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

// Rating Request DTO
class RatingRequest {
  final int rating;

  RatingRequest({
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
    };
  }
}

// Assignment Request DTO
class AssignmentRequest {
  final String assignedTo;

  AssignmentRequest({
    required this.assignedTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'assignedTo': assignedTo,
    };
  }
}
