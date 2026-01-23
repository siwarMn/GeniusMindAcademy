import 'package:flutter/material.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final int level;
  final bool active;
  final bool completed;
  final List<Question> questions;

  Quiz(
      {required this.id,
      required this.title,
      required this.description,
      required this.level,
      required this.active,
      required this.completed,
      required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        level: json['level'] ?? 1,
        active: json['active'] ?? false,
        completed: json['completed'] ?? false,
        questions: (json['questions'] as List<dynamic>?)
                ?.map((q) => Question.fromJson(q))
                .toList() ??
            [],
      );

  // Méthode utilitaire pour obtenir le niveau en texte
  String get levelText {
    switch (level) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        return 'Non spécifié';
    }
  }

// Méthode utilitaire pour obtenir la couleur du niveau
  Color get levelColor {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Question {
  final int id;
  final String label; // correspond à Question.label côté Spring
  final List<Option> options;

  Question({required this.id, required this.label, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        label: json['label'] ?? '',
        options: (json['options'] as List<dynamic>?)
                ?.map((o) => Option.fromJson(o))
                .toList() ??
            [],
      );
}

class Option {
  final int id;
  final String label; // correspond à Option.label côté Spring
  final bool correct;

  Option({required this.id, required this.label, required this.correct});

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'],
        label: json['label'] ?? '',
        correct: json['correct'] ?? false,
      );
}

class QuizScore {
  final int id;
  final int studentId;
  final int quizId;
  final int? score;
  final int? total;
  final int? durationSec;
  final bool? finished;

  QuizScore({
    required this.id,
    required this.studentId,
    required this.quizId,
    this.score,
    this.total,
    this.durationSec,
    this.finished,
  });

  factory QuizScore.fromJson(Map<String, dynamic> json) => QuizScore(
        id: json['id'] ?? 0,
        studentId: json['studentId'] ?? 0,
        quizId: json['quizId'] ?? 0,
        score: json['score'],
        total: json['total'],
        durationSec: json['duration'] ?? json['durationSec'],
        finished: json['finished'] ?? false,
      );
}
