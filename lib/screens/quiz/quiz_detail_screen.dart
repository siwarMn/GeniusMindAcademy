import 'package:flutter/material.dart';
import 'package:codajoy/models/quiz_model.dart';

class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizDetailScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  // Variable pour suivre la réponse sélectionnée
  String? _selectedAnswer;
  bool _showCorrectAnswer = false;

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quiz;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Quiz'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête simplifiée
            _buildHeader(quiz),

            // Contenu principal
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Description
                  _buildDescription(quiz),

                  SizedBox(height: 20),

                  // Question
                  _buildQuestion(quiz),

                  SizedBox(height: 20),

                  // Réponses
                  _buildAnswers(quiz),

                  SizedBox(height: 20),

                  // Informations
                  _buildInfo(quiz),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  // ============================
  // 1. EN-TÊTE DU QUIZ
  // ============================
  Widget _buildHeader(Quiz quiz) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            quiz.title ?? 'Quiz sans titre',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),

          SizedBox(height: 10),

          // Informations rapides
          Row(
            children: [
              // Nombre de questions
              _buildInfoChip(
                icon: Icons.question_answer,
                text:
                    '${quiz.questions.length} question${quiz.questions.length > 1 ? 's' : ''}',
              ),

              SizedBox(width: 10),

              // Niveau
              _buildInfoChip(
                icon: Icons.school,
                text: 'Niveau ${quiz.levelId ?? 1}',
              ),

              SizedBox(width: 10),

              // Statut
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: quiz.isActive == true
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
                            quiz.isActive == true ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      quiz.isActive == true ? 'Actif' : 'Inactif',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            quiz.isActive == true ? Colors.green : Colors.red,
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

  // ============================
  // 2. DESCRIPTION
  // ============================
  Widget _buildDescription(Quiz quiz) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blue, size: 20),
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

  // ============================
  // 3. QUESTION
  // ============================
  Widget _buildQuestion(Quiz quiz) {
    // Prend la première question pour la démonstration
    final firstQuestion = quiz.questions.isNotEmpty ? quiz.questions[0] : null;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Question Exemple',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              firstQuestion?.question ?? 'Pas de question disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // 4. RÉPONSES
  // ============================
  Widget _buildAnswers(Quiz quiz) {
    // Prend les options de la première question
    final firstQuestion = quiz.questions.isNotEmpty ? quiz.questions[0] : null;
    final options = firstQuestion?.options ?? [];
    final correctAnswer = firstQuestion?.correctAnswer;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Options de réponse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),

                // Bouton pour révéler la réponse
                if (_selectedAnswer != null && !_showCorrectAnswer)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showCorrectAnswer = true;
                      });
                    },
                    icon: Icon(Icons.visibility, size: 16),
                    label: Text('Vérifier'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 15),

            // Liste des options
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == correctAnswer;

              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    if (_selectedAnswer == null) {
                      setState(() {
                        _selectedAnswer = option;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getAnswerColor(isSelected, isCorrect),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getBorderColor(isSelected, isCorrect),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Numéro
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _getNumberColor(isSelected, isCorrect),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color:
                                    _getNumberTextColor(isSelected, isCorrect),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Texte de l'option
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 15,
                              color: _getTextColor(isSelected, isCorrect),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),

                        // Icône de validation - CORRECTION ICI
                        if ((isSelected || _showCorrectAnswer) && isCorrect)
                          Icon(Icons.check, color: Colors.green, size: 20),
                        if (isSelected && !isCorrect)
                          Icon(Icons.close, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            // Affichage de la réponse correcte
            if (_showCorrectAnswer && correctAnswer != null)
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Réponse correcte: $correctAnswer',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================
  // 5. INFORMATIONS
  // ============================
  Widget _buildInfo(Quiz quiz) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations du quiz',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 10),

            // Liste d'informations
            _buildInfoItem('ID', '#${quiz.id}'),
            _buildInfoItem('Catégorie', 'Général'),
            _buildInfoItem('Difficulté', _getDifficulty(quiz.levelId)),
            _buildInfoItem('Temps estimé',
                '${_getTimeEstimate(quiz.questions.length)} min'),
            _buildInfoItem('Questions', '${quiz.questions.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
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

  // ============================
  // 6. BOUTONS DU BAS
  // ============================
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Bouton Commencer
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _startQuiz(context),
              icon: Icon(Icons.play_arrow, size: 20),
              label: Text('Commencer le quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          // Bouton Partager
          IconButton(
            onPressed: () => _shareQuiz(context),
            icon: Icon(Icons.share, color: Colors.blue),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue[50],
              padding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // FONCTIONS D'AIDE - COULEURS
  // ============================
  Color _getAnswerColor(bool isSelected, bool isCorrect) {
    if (_showCorrectAnswer && isCorrect) {
      return Colors.green[50]!;
    }
    if (isSelected) {
      return isCorrect ? Colors.green[50]! : Colors.red[50]!;
    }
    return Colors.grey[50]!;
  }

  Color _getBorderColor(bool isSelected, bool isCorrect) {
    if (_showCorrectAnswer && isCorrect) {
      return Colors.green[200]!;
    }
    if (isSelected) {
      return isCorrect ? Colors.green[300]! : Colors.red[300]!;
    }
    return Colors.grey[300]!;
  }

  Color _getNumberColor(bool isSelected, bool isCorrect) {
    if (_showCorrectAnswer && isCorrect) {
      return Colors.green;
    }
    if (isSelected) {
      return isCorrect ? Colors.green : Colors.red;
    }
    return Colors.blue[100]!;
  }

  Color _getNumberTextColor(bool isSelected, bool isCorrect) {
    if (_showCorrectAnswer && isCorrect) {
      return Colors.white;
    }
    if (isSelected) {
      return Colors.white;
    }
    return Colors.blue[800]!;
  }

  Color _getTextColor(bool isSelected, bool isCorrect) {
    if (_showCorrectAnswer && isCorrect) {
      return Colors.green[900]!;
    }
    if (isSelected) {
      return isCorrect ? Colors.green[900]! : Colors.red[900]!;
    }
    return Colors.grey[800]!;
  }

  // ============================
  // FONCTIONS UTILITAIRES
  // ============================
  String _getDifficulty(int? levelId) {
    switch (levelId) {
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

  int _getTimeEstimate(int questionCount) {
    // Estimation : 1 minute par question
    return (questionCount * 1.5).ceil();
  }

  // ============================
  // ACTIONS
  // ============================
  void _startQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Commencer le quiz'),
        content: Text(
            'Voulez-vous commencer le quiz "${widget.quiz.title}" ?\n\n'
            'Il contient ${widget.quiz.questions.length} question${widget.quiz.questions.length > 1 ? 's' : ''}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showQuizStarted(context);
            },
            child: Text('Commencer'),
          ),
        ],
      ),
    );
  }

  void _showQuizStarted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz "${widget.quiz.title}" lancé avec succès !'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareQuiz(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lien du quiz copié dans le presse-papier'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
