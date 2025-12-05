// lib/models/user_model.dart
class UserModel {
  final int? id;
  final String firstname;
  final String lastname;
  final String email;
  final String niveau;
  final int? score;
  final String? role;

  UserModel({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.niveau,
    this.score = 0,
    this.role = 'STUDENT',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      niveau: json['niveau'] ?? '',
      score: json['score'] ?? 0,
      role: json['role'] ?? 'STUDENT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'niveau': niveau,
      'score': score,
      'role': role,
    };
  }
}