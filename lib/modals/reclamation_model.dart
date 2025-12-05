// lib/models/reclamation_model.dart
class ReclamationModel {
  final int? id;
  final String titre;
  final String categorie;
  final String description;
  final String creerpar;
  final String status; // PENDING, IN_PROGRESS, RESOLVED
  final DateTime? createdAt;
  final String? response;

  ReclamationModel({
    this.id,
    required this.titre,
    required this.categorie,
    required this.description,
    required this.creerpar,
    this.status = 'PENDING',
    this.createdAt,
    this.response,
  });

  factory ReclamationModel.fromJson(Map<String, dynamic> json) {
    return ReclamationModel(
      id: json['id'],
      titre: json['titre'] ?? '',
      categorie: json['categorie'] ?? '',
      description: json['description'] ?? '',
      creerpar: json['creerpar'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'categorie': categorie,
      'description': description,
      'creerpar': creerpar,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'response': response,
    };
  }
}