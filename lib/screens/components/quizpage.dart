import 'package:flutter/material.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _questionIndex = 0;
  int _totalScore = 0;

  List<String> _questions = [
    'What is the capital of France?',
    'Who painted the Mona Lisa?',
    'What is the largest planet in our solar system?',
    'Which mammal can fly?',
    'What year did the Titanic sink?'
  ];

  List<List<String>> _options = [
    ['Paris', 'London', 'Berlin', 'Rome'],
    ['Leonardo da Vinci', 'Pablo Picasso', 'Vincent van Gogh', 'Michelangelo'],
    ['Jupiter', 'Saturn', 'Mars', 'Earth'],
    ['Bat', 'Bird', 'Flying Squirrel', 'Pegasus'],
    ['1912', '1914', '1918', '1922'],
  ];

  List<int> _answers = [0, 0, 0, 1, 0]; // Index of correct answers

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _answers[_questionIndex]) {
      _totalScore += 1;
    }
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
      });
    } else {
      // Quiz finished
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Terminé'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Score total: $_totalScore',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: _totalScore == 5 ? Colors.green : _totalScore >= 3 ? Colors.orange : Colors.red,
                  ),
                ),
                SizedBox(height: 20.0),
                _totalScore == 5
                    ? Icon(
                  Icons.sentiment_very_satisfied,
                  size: 50.0,
                  color: Colors.green,
                )
                    : _totalScore >= 3
                    ? Icon(
                  Icons.sentiment_satisfied,
                  size: 50.0,
                  color: Colors.orange,
                )
                    : Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50.0,
                  color: Colors.red,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetQuiz();
                },
                child: Text('Recommencer Quiz'),
              ),
            ],
          );
        },
      );
      // Reset score
      _totalScore = 0;
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              _questions[_questionIndex],
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
          ..._options[_questionIndex].map((option) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  _answerQuestion(_options[_questionIndex].indexOf(option));
                },
                child: Text(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 20.0),
          if (_questionIndex == _questions.length - 1)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _answerQuestion(-1); // Dummy function call to trigger showing result
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Couleur du texte
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Taille du bouton
                ),
                child: Text(
                  'Terminer',
                  style: TextStyle(fontSize: 18.0), // Taille du texte
                ),
              ),
            ),

        ],
      ),
    );
  }
}




