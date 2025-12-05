import 'package:codajoy/controllers/quiz_controller.dart';

abstract class QuizService {
  Future<List<Quiz>> getAllQuizzes();
}

class MockQuizService implements QuizService {
  @override
  Future<List<Quiz>> getAllQuizzes() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    return [
      Quiz(
        id: 1,
        question: "Quelle est la capitale de la France ?",
        response1: "Londres",
        response2: "Paris",
        response3: "Berlin",
        correct: "Paris",
        levelId: 1,
      ),
      Quiz(
        id: 2,
        question: "Combien font 2 + 2 ?",
        response1: "3",
        response2: "4",
        response3: "5",
        correct: "4",
        levelId: 1,
      ),
    ];
  }
}
