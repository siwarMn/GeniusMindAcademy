import 'package:http/http.dart' as http;
import 'dart:convert';

/// Script de test pour vérifier la connexion au backend Spring Boot
///
/// Pour exécuter ce test:
/// dart run test_backend_connection.dart
void main() async {
  print('=================================');
  print('Test de connexion au backend');
  print('=================================\n');

  // URLs à tester selon votre environnement
  final urls = [
    'http://localhost:8082/api/v1/forum/questions',
    'http://10.0.2.2:8082/api/v1/forum/questions', // Android Emulator
    // Ajoutez votre IP locale si nécessaire
    // 'http://192.168.1.XXX:8082/api/v1/forum/questions',
  ];

  for (final url in urls) {
    await testConnection(url);
  }

  print('\n=================================');
  print('Tests terminés');
  print('=================================');
}

Future<void> testConnection(String url) async {
  print('Test de connexion à: $url');
  print('---------------------------------');

  try {
    final response = await http
        .get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print('✅ Connexion réussie!');
      print('Status: ${response.statusCode}');

      if (data is List) {
        print('Nombre de questions: ${data.length}');

        if (data.isNotEmpty) {
          print('\nPremière question:');
          print('  - ID: ${data[0]['id']}');
          print('  - Titre: ${data[0]['title']}');
          print('  - Auteur: ${data[0]['author']}');
          print('  - Votes: ${data[0]['votes']}');
          print('  - Vues: ${data[0]['views']}');
        }
      }
    } else {
      print('⚠️ Réponse avec code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Erreur de connexion: $e');
  }

  print('');
}
