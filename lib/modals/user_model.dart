// lib/models/user_model.dart
class UserModel {
  final int? id;
  final String firstname;
  final String lastname;
  final String email;
  final String? niveau;
  final int? score;
  final String? role;

  final String? image;
  final String? password;

  UserModel({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.niveau, // Now nullable and optional
    this.score = 0,
    this.role = 'USER',
    this.password,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      niveau: json['niveau'], // Can be null
      score: json['score'] ?? 0,
      role: json['role'] ?? 'USER',
      image: json['image'],
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
      'image': image, // Include image in JSON
      if (password != null) 'password': password,
    };
  }
}