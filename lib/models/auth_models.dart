class AuthenticationRequest {
  final String email;
  final String password;

  AuthenticationRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String niveau;
  final String role;

  RegisterRequest({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.niveau,
    this.role = 'USER',
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'niveau': niveau,
      'role': role,
    };
  }
}

class AuthenticationResponse {
  final String? token;
  final String? role;
  final String? nom;
  final String? prenom;
  final String? image;
  final String? niveau;

  AuthenticationResponse({
    this.token,
    this.role,
    this.nom,
    this.prenom,
    this.image,
    this.niveau,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'],
      role: json['role']?.toString(),
      nom: json['Nom'] ?? json['nom'],
      prenom: json['prenom'] ?? json['Prenom'],
      image: json['image'],
      niveau: json['niveau'],
    );
  }
}
