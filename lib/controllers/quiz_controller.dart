import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/services/quiz_service.dart';
import 'package:codajoy/models/quiz_model.dart';
import 'package:codajoy/screens/quiz/quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late Future<List<Quiz>> _futureQuizzes;
  LoginController login = Get.put(LoginController());

  // Crée une instance de MockQuizService
  final QuizService quizService = MockQuizService();

  Future<List<Quiz>> getAllQuizzes() async {
    try {
      // Utilise le service pour récupérer les données
      return await quizService.getAllQuizzes();
    } catch (e) {
      print('Erreur lors du chargement: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _futureQuizzes = getAllQuizzes();
  }

  Future<void> _refreshQuizzes() async {
    setState(() {
      _futureQuizzes = getAllQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        // bouton refresh
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
            // État de chargement
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

            // Erreur
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

            // Données disponibles
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final quizzes = snapshot.data!;

              return RefreshIndicator(
                onRefresh: _refreshQuizzes,
                color: Colors.blue,
                child: ListView.builder(
                  itemCount: quizzes.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];

                    return _buildQuizCard(quiz, context);
                  },
                ),
              );
            }

            // Aucune donnée
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
                  SizedBox(height: 8),
                  Text(
                    'Commencez par créer votre premier quiz',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Ajouter création de quiz
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Création de quiz à implémenter'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Créer un quiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ajouter un nouveau quiz'),
              backgroundColor: Colors.green,
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Nouveau quiz',
      ),
    );
  }

  // Widget pour construire une carte de quiz
  Widget _buildQuizCard(Quiz quiz, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Action quand on clique sur le quiz
          _showQuizDetails(context, quiz);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne 1: Titre et statut
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildStatusIndicator(quiz.isActive ?? false),
                ],
              ),

              SizedBox(height: 10),

              // Ligne 2: Description
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

              // Ligne 3: Informations et bouton
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Niveau ${quiz.levelId ?? 1}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[700],
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
                        '1 question',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),

                  // Bouton Voir
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

  // Widget pour l'indicateur de statut
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

  // Fonction pour afficher les détails du quiz
  void _showQuizDetails(BuildContext context, Quiz quiz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Détails du Quiz',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.title, color: Colors.blue),
                title: Text('Titre'),
                subtitle: Text(
                  quiz.title ?? 'Non spécifié',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.green),
                title: Text('Description'),
                subtitle: Text(
                  quiz.description ?? 'Aucune description',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                leading: Icon(Icons.school, color: Colors.orange),
                title: Text('Niveau'),
                subtitle: Text(
                  'Niveau ${quiz.levelId ?? 1}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle,
                    color: quiz.isActive == true ? Colors.green : Colors.red),
                title: Text('Statut'),
                subtitle: Text(
                  quiz.isActive == true ? 'Actif' : 'Inactif',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: quiz.isActive == true ? Colors.green : Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Fermer',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Ferme le modal
                        // TODO: Navigation vers l'écran complet des détails
                        // ScaffoldMessenger.of(context).showSnackBar(
                        // SnackBar(
                        // content: Text('Ouverture des détails complets'),
                        // backgroundColor: Colors.blue,
                        //),
                        // );

                        // Ouvre l'écran de détails complet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizDetailScreen(quiz: quiz),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Ouvrir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
