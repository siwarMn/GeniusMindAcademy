import 'package:codajoy/models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class QuizService {
  /*Future<List<Quiz>> getAllQuizzes();
  Future<Quiz> getQuizById(int id);*/
  Future<List<Quiz>> getStudentQuizzes(String studentId);
  Future<Quiz> getQuizDetails(int quizId);
  Future<void> startQuiz(String studentId, int quizId);
  Future<List<QuizScore>> getStudentScores(String studentId);

  Future<QuizScore> submitQuizScore({
    required String studentId,
    required int quizId,
    required int score,
    required int total,
    required int durationSec,
  });

  Future<QuizScore> getQuizResult(String studentId, int quizId);
}

class ApiQuizService implements QuizService {
  final _storage = const FlutterSecureStorage();

  final String baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/auth/quiz'
      : 'http://localhost:8080/api/v1/auth/quiz';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No token found. Please login first.');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
/*
  @override
  Future<List<Quiz>> getAllQuizzes() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Quiz.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement quiz : ${response.statusCode}');
  }

  @override
  Future<Quiz> getQuizById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    }
    throw Exception('Quiz non trouvé : ${response.statusCode}');
  }*/

  @override
  Future<List<Quiz>> getStudentQuizzes(String studentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/$studentId'),
      headers: await _headers(),
    );
    final body = jsonDecode(res.body) as List;
    return body.map((e) => Quiz.fromJson(e)).toList();
  }

  @override
  Future<Quiz> getQuizDetails(int quizId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/details/$quizId'),
      headers: await _headers(),
    );
    return Quiz.fromJson(jsonDecode(res.body));
  }

  @override
  Future<void> startQuiz(String studentId, int quizId) async {
    print("baseUrl " + baseUrl);
    await http.post(
      Uri.parse('$baseUrl/start'),
      headers: await _headers(),
      body: jsonEncode({'studentId': studentId, 'quizId': quizId}),
    );
  }

  @override
  Future<List<QuizScore>> getStudentScores(String studentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/scores/$studentId'),
      headers: await _headers(),
    );
    final body = jsonDecode(res.body) as List;
    return body.map((e) => QuizScore.fromJson(e)).toList();
  }

  @override
  Future<QuizScore> submitQuizScore({
    required String studentId,
    required int quizId,
    required int score,
    required int total,
    required int durationSec,
  }) async {
    final uri = Uri.parse('$baseUrl/submit').replace(queryParameters: {
      'studentId': studentId,
      'quizId': quizId.toString(),
      'score': score.toString(),
      'total': total.toString(),
      'duration': durationSec.toString(),
    });

    final res = await http.post(
      uri,
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return QuizScore.fromJson(body);
    } else {
      throw Exception(
          'Erreur lors de la soumission du score: ${res.statusCode}');
    }
  }

  @override
  Future<QuizScore> getQuizResult(String studentId, int quizId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/result/$studentId/$quizId'),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return QuizScore.fromJson(body);
    } else {
      throw Exception('Erreur récupération résultat: ${res.statusCode}');
    }
  }
}
/**
class MockQuizService implements QuizService {
  @override
  Future<List<Quiz>> getAllQuizzes() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      Quiz(
        id: 1,
        title: 'Quiz de Mathématiques Avancées',
        description: 'Testez vos connaissances en algèbre et géométrie avancée',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quelle est la valeur de 2x + 5 = 15 ?',
            options: ['x = 5', 'x = 10', 'x = 7.5', 'x = 8'],
            correctAnswer: 'x = 5',
            explanation: '2x + 5 = 15 => 2x = 10 => x = 5',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quelle est l\'aire d\'un cercle de rayon 3 cm ?',
            options: ['9π cm²', '6π cm²', '3π cm²', '12π cm²'],
            correctAnswer: '9π cm²',
            explanation: 'Aire = π × r² = π × 3² = 9π',
          ),
        ],
        isActive: true,
        levelId: 3,
      ),
      Quiz(
        id: 2,
        title: 'Quiz de Français - Grammaire',
        description: 'Perfectionnez votre grammaire française',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quel est le pluriel de "cheval" ?',
            options: ['Chevals', 'Chevaux', 'Chevales', 'Chevauxs'],
            correctAnswer: 'Chevaux',
            explanation: 'Les mots terminant en -al font -aux au pluriel',
          ),
        ],
        isActive: true,
        levelId: 2,
      ),
    ];
  }

  @override
  Future<Quiz> getQuizById(int id) async {
    final quizzes = await getAllQuizzes();
    return quizzes.firstWhere((quiz) => quiz.id == id);
  }
}*/
