import 'package:flutter/material.dart';
import 'package:codajoy/models/quiz_model.dart';
import 'package:codajoy/services/quiz_service.dart';
import 'package:get/get.dart';
import 'quiz_play.dart';

class QuizDetailScreen extends StatefulWidget {
  final int quizId;
  final String? studentId;

  const QuizDetailScreen(
      {Key? key, required this.quizId, required this.studentId})
      : super(key: key);

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  late Future<Quiz> _futureQuiz;
  final QuizService quizService = ApiQuizService();

  @override
  void initState() {
    super.initState();
    _futureQuiz = quizService.getQuizDetails(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Quiz'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<Quiz>(
        future: _futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Quiz non trouvé'));
          }

          final quiz = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.blue[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title ?? 'Quiz sans titre',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.question_answer,
                            text:
                                '${quiz.questions.length} question${quiz.questions.length > 1 ? 's' : ''}',
                          ),
                          SizedBox(width: 10),
                          _buildInfoChip(
                            icon: Icons.school,
                            text: quiz.levelText,
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: quiz.active
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color:
                                        quiz.active ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  quiz.active ? 'Actif' : 'Inactif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        quiz.active ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDescription(quiz),
                      SizedBox(height: 20),
                      _buildExampleQuestion(quiz),
                      SizedBox(height: 20),
                      _buildQuizInfo(quiz),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Quiz>(
        future: _futureQuiz,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          final quiz = snapshot.data!;
          return _buildBottomButton(context, quiz);
        },
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Quiz quiz) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              quiz.description ?? 'Aucune description disponible',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(Quiz quiz) {
    final firstQuestion = quiz.questions.isNotEmpty ? quiz.questions[0] : null;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Exemple de question',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (firstQuestion != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstQuestion.label, // ✅ utiliser le champ correct
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: firstQuestion.options.map((option) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 +
                                      firstQuestion.options.indexOf(option)),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(child: Text(option.label)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            else
              Text('Pas de question disponible'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInfo(Quiz quiz) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            _buildInfoRow('Niveau', quiz.levelText),
            _buildInfoRow('Questions', '${quiz.questions.length}'),
            _buildInfoRow('Temps estimé', '${quiz.questions.length * 2} min'),
            _buildInfoRow('Statut', quiz.active ? 'Actif' : 'Inactif'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, Quiz quiz) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => QuizPlayScreen(quiz: quiz, studentId: widget.studentId));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow),
            SizedBox(width: 10),
            Text(
              'Commencer le quiz',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
