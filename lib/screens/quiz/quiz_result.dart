import 'package:flutter/material.dart';
import 'package:codajoy/models/quiz_model.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final List<String?> userAnswers;
  final int score;

  const QuizResultScreen({
    Key? key,
    required this.quiz,
    required this.userAnswers,
    required this.score,
  }) : super(key: key);

  double get percentage => (score / quiz.questions.length) * 100;

  String get resultMessage {
    if (percentage >= 80) return 'Excellent !';
    if (percentage >= 60) return 'Bon travail !';
    if (percentage >= 40) return 'Pas mal !';
    return 'À améliorer';
  }

  Color get resultColor {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          // Résumé
          Container(
            padding: EdgeInsets.all(30),
            color: Colors.blue[50],
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: resultColor,
                ),
                SizedBox(height: 20),
                Text(
                  resultMessage,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: resultColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$score/${quiz.questions.length} bonnes réponses',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '${percentage.round()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),

          // Détail des réponses
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final userAnswer = userAnswers[index];
                final isCorrect = userAnswer == question.correctAnswer;

                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  color: isCorrect ? Colors.green[50] : Colors.red[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  isCorrect ? Colors.green : Colors.red,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                question.question,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Votre réponse: ${userAnswer ?? "Non répondue"}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Bonne réponse: ${question.correctAnswer}',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (question.explanation != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Explication:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(question.explanation!),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Boutons d'action
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Retour'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Accueil'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
