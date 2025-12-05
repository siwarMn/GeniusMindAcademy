class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class Quiz {
  final int? id;
  final String? title;
  final List<QuizQuestion> questions;
  final String? response1;
  final String? response2;
  final String? response3;
  final String? correct;
  final int? levelId;
  final bool? isActive;
  final String? description;

  Quiz({
    this.id,
    this.title,
    required this.questions,
    this.response1,
    this.response2,
    this.response3,
    this.correct,
    this.levelId,
    this.isActive = true,
    this.description,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 1,
      title: json['title'] ?? 'Titre du Quiz',
      questions: (json['questions'] as List?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList() ??
          [],
      response1: json['response1'] ?? 'Option A',
      response2: json['response2'] ?? 'Option B',
      response3: json['response3'] ?? 'Option C',
      correct: json['correct'] ?? 'Option A',
      levelId: json['levelId'] ?? 1,
      isActive: json['isActive'] ?? true,
      description: json['description'] ?? 'Description du quiz',
    );
  }
}
