import 'package:codajoy/models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class QuizService {
  Future<List<Quiz>> getAllQuizzes();
  Future<Quiz> getQuizById(int id);
}

class ApiQuizService implements QuizService {
  final String baseUrl = 'http://localhost:51942/api/quiz';

  Future<List<Quiz>> getAllQuizzes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Quiz.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement quiz');
    }
  }

  Future<Quiz> getQuizById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Quiz non trouvé');
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
