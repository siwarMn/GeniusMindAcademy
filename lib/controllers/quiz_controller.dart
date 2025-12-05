import 'package:codajoy/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the Quiz model class
class Quiz {
  final int ? id;
  final String? question;
  final String? response1;
  final String? response2;
  final String? response3;
  final String? correct; // Assuming correct response is represented by an integer
final int ?levelId;
  Quiz({
   this.id,
     this.question,
     this.response1,
    this.response2,
    this.response3,
     this.correct,
     this.levelId,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id']?? 1,
      question: json['question']??'question', 
      response1: json['response1']??'aha',
      response2: json['response2']??'may',
      response3: json['response3'] ??'no',
      correct: json['correct'] ??' yes',
      levelId: json['levelId'] ?? 0,
    );
  }
}

// Widget to display a list of quizzes
class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late Future<List<Quiz>> _futureQuizzes;
LoginController login=Get.put(LoginController());
  Future<List<Quiz>> getAllQuizzes() async {
    
  Future< String ?> authtoken=login.gettoken();
    final response = await http.get(
      Uri.parse('http://192.168.1.17:8080/api/v1/auth/getAllQuizzes'),
      headers: {'Authorization': '$authtoken'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((quiz) => Quiz.fromJson(quiz)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureQuizzes = getAllQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: _futureQuizzes,
       builder: (context, snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    final quiz = snapshot.data![index];
    // Variable to hold the selected option, initialized to -1 (no option selected)
    int selectedOptionIndex = -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            quiz.question!,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedOptionIndex = 0; // Update selected option index to the first option
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedOptionIndex == 0 ? Colors.green : null, // Highlight color for correct option
          ),
          child: Text(quiz.response1!),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedOptionIndex = 1; // Update selected option index to the second option
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedOptionIndex == 1 ? Colors.green : null, // Highlight color for correct option
          ),
          child: Text(quiz.response2!),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedOptionIndex = 2; // Update selected option index to the third option
            });
          },
          style: ElevatedButton.styleFrom(
           backgroundColor: selectedOptionIndex == 2 ? Colors.green : null, // Highlight color for correct option
          ),
          child: Text(quiz.response3!),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedOptionIndex = 2; // Update selected option index to the third option
            });
          },
          style: ElevatedButton.styleFrom(
           backgroundColor: selectedOptionIndex == 2 ? Colors.green : null, // Highlight color for correct option
          ),
          child: Text(quiz.response3!),
        ),
      ],
    );
  },
);
}else{
  return Text("no");
}}
    ));
  }
}
