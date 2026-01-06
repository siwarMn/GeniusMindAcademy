import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:codajoy/services/quiz_service.dart';
import 'package:codajoy/models/quiz_model.dart';
import 'quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late Future<List<Quiz>> _futureQuizzes;
  final QuizService quizService = ApiQuizService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? userIdStr;

  @override
  void initState() {
    super.initState();
    _futureQuizzes = _getAllQuizzes();
  }

  Future<List<Quiz>> _getAllQuizzes() async {
    try {
      userIdStr = await _storage.read(key: "nom");
      if (userIdStr == null) return [];
      return await quizService.getStudentQuizzes(userIdStr!);
    } catch (e) {
      print('Erreur lors du chargement: $e');
      return [];
    }
  }

  Future<void> _refreshQuizzes() async {
    setState(() {
      _futureQuizzes = _getAllQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshQuizzes,
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: FutureBuilder<List<Quiz>>(
          future: _futureQuizzes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _refreshQuizzes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Réessayer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.quiz_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucun quiz disponible',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            final quizzes = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshQuizzes,
              color: Colors.blue,
              child: ListView.builder(
                itemCount: quizzes.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return QuizCard(
                    quiz: quizzes[index],
                    userIdStr: userIdStr,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDetailScreen(
                              quizId: quizzes[index].id, studentId: userIdStr),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final String? userIdStr;

  const QuizCard({
    Key? key,
    required this.quiz,
    required this.onTap,
    required this.userIdStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = quiz.completed;

    return Opacity(
      opacity: isCompleted ? 0.85 : 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(),
                ],
              ),
              const SizedBox(height: 10),
              if (quiz.description.isNotEmpty)
                Text(
                  quiz.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: quiz.levelColor),
                      const SizedBox(width: 5),
                      Text(
                        quiz.levelText,
                        style: TextStyle(
                          fontSize: 14,
                          color: quiz.levelColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Icon(Icons.question_answer,
                          size: 16, color: Colors.purple),
                      const SizedBox(width: 5),
                      Text(
                        '${quiz.questions.length} question${quiz.questions.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                  // Bouton
                  isCompleted
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            if (userIdStr == null) return;
                            final quizService = ApiQuizService();
                            try {
                              final result = await quizService.getQuizResult(
                                  userIdStr!, quiz.id);

                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 400),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Icon et score
                                            Icon(
                                              Icons.emoji_events,
                                              size: 60,
                                              color: result.score != null &&
                                                      result.total != null
                                                  ? (result.score! /
                                                              result.total! >=
                                                          0.8
                                                      ? Colors.green
                                                      : result.score! /
                                                                  result
                                                                      .total! >=
                                                              0.6
                                                          ? Colors.orange
                                                          : Colors.red)
                                                  : Colors.grey,
                                            ),
                                            SizedBox(height: 16),
                                            // Message de résultat
                                            Text(
                                              result.score != null &&
                                                      result.total != null
                                                  ? (() {
                                                      double pct =
                                                          result.score! /
                                                              result.total!;
                                                      if (pct >= 0.8)
                                                        return 'Excellent !';
                                                      if (pct >= 0.6)
                                                        return 'Bon travail !';
                                                      if (pct >= 0.4)
                                                        return 'Pas mal !';
                                                      return 'À améliorer';
                                                    })()
                                                  : 'Résultat indisponible',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: result.score != null &&
                                                        result.total != null
                                                    ? (result.score! /
                                                                result.total! >=
                                                            0.8
                                                        ? Colors.green
                                                        : result.score! /
                                                                    result
                                                                        .total! >=
                                                                0.6
                                                            ? Colors.orange
                                                            : Colors.red)
                                                    : Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 8),
                                            // Score numérique et pourcentage
                                            if (result.score != null &&
                                                result.total != null)
                                              Column(
                                                children: [
                                                  Text(
                                                    '${result.score}/${result.total}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.blue[800],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '${((result.score! / result.total!) * 100).round()}%',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            SizedBox(height: 24),
                                            // Bouton Fermer
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Fermer',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Impossible de récupérer le résultat')),
                              );
                            }
                          },
                          icon: const Icon(Icons.score, size: 18),
                          label: const Text('Voir score'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: onTap,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Voir',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios,
                                  size: 12, color: Colors.blue[700]),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color bgColor;
    Color borderColor;
    String text;

    if (quiz.completed) {
      bgColor = Colors.grey.withOpacity(0.15);
      borderColor = Colors.grey;
      text = 'Terminé';
    } else if (quiz.active) {
      bgColor = Colors.green.withOpacity(0.15);
      borderColor = Colors.green;
      text = 'Actif';
    } else {
      bgColor = Colors.red.withOpacity(0.15);
      borderColor = Colors.red;
      text = 'Inactif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: borderColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: borderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
