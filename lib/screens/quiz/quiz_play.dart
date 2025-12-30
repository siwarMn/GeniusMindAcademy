import 'package:flutter/material.dart';
import 'package:codajoy/models/quiz_model.dart';
import 'quiz_result.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizPlayScreenState createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentIndex = 0;
  List<String?> _userAnswers = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.quiz.questions.length, null);
  }

  QuizQuestion get _currentQuestion => widget.quiz.questions[_currentIndex];

  void _selectAnswer(String answer) {
    if (_userAnswers[_currentIndex] == null) {
      setState(() {
        _userAnswers[_currentIndex] = answer;
        if (answer == _currentQuestion.correctAnswer) {
          _score++;
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          userAnswers: _userAnswers,
          score: _score,
        ),
      ),
    );
  }

  void _jumpToQuestion(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz: ${widget.quiz.title}',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_score/${widget.quiz.questions.length}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Navigation des questions
          Container(
            height: 70,
            color: Colors.grey[50],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.quiz.questions.length,
              itemBuilder: (context, index) {
                bool isAnswered = _userAnswers[index] != null;
                bool isCurrent = index == _currentIndex;

                return GestureDetector(
                  onTap: () => _jumpToQuestion(index),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.blue
                          : isAnswered
                              ? Colors.green
                              : Colors.grey[300],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isCurrent ? Colors.blue[800]! : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Question et réponses
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Question
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${_currentIndex + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _currentQuestion.question,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Réponses
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        String option = _currentQuestion.options[index];
                        bool isSelected = _userAnswers[_currentIndex] == option;
                        bool isCorrect =
                            option == _currentQuestion.correctAnswer;

                        return Card(
                          color: isSelected
                              ? (isCorrect ? Colors.green[50] : Colors.red[50])
                              : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.grey[200],
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(option),
                            onTap: () => _selectAnswer(option),
                            trailing: isSelected
                                ? Icon(
                                    isCorrect ? Icons.check : Icons.close,
                                    color:
                                        isCorrect ? Colors.green : Colors.red,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  // Boutons de navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentIndex > 0 ? _previousQuestion : null,
                        child: Text('Précédent'),
                      ),
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        child: Text(
                          _currentIndex < widget.quiz.questions.length - 1
                              ? 'Suivant'
                              : 'Terminer',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
