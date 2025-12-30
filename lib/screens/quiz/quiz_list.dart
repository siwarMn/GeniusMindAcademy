import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/services/quiz_service.dart';
import 'package:codajoy/models/quiz_model.dart';
import 'quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late Future<List<Quiz>> _futureQuizzes;
  //final QuizService quizService = MockQuizService(); // Correction ici

  final QuizService quizService = ApiQuizService();

  @override
  void initState() {
    super.initState();
    _futureQuizzes = _getAllQuizzes();
  }

  Future<List<Quiz>> _getAllQuizzes() async {
    try {
      return await quizService.getAllQuizzes();
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
        title: Text(
          'Liste des Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
          selectionColor: Colors.white,
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Chargement des quiz...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Impossible de charger les quiz',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _refreshQuizzes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text(
                        'Réessayer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final quizzes = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refreshQuizzes,
                color: Colors.blue,
                child: ListView.builder(
                  itemCount: quizzes.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return QuizCard(
                      quiz: quizzes[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetailScreen(quiz: quizzes[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun quiz disponible',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget QuizCard réutilisable
class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const QuizCard({
    Key? key,
    required this.quiz,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quiz.title ?? 'Quiz sans titre',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildStatusIndicator(quiz.isActive ?? false),
                ],
              ),
              SizedBox(height: 10),
              if (quiz.description != null && quiz.description!.isNotEmpty)
                Text(
                  quiz.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 16,
                        color: quiz.levelColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        quiz.levelText,
                        style: TextStyle(
                          fontSize: 14,
                          color: quiz.levelColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 15),
                      Icon(
                        Icons.question_answer,
                        size: 16,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${quiz.questions.length} question${quiz.questions.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.blue[700],
                        ),
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

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Text(
            isActive ? 'Actif' : 'Inactif',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
