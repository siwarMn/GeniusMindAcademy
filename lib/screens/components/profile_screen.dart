import 'package:codajoy/controllers/courses_controller.dart';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/controllers/quiz_controller.dart';
import 'package:codajoy/screens/components/ModifierProfile.dart';
import 'package:codajoy/screens/components/chatbot.dart';
import 'package:codajoy/screens/login_screen.dart';
import 'package:codajoy/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../7th_grade_lessons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    TextEditingController searchController = TextEditingController();

    void performSearch(String searchText) {
      searchText = searchText.toLowerCase();

      // Filtrer les résultats en fonction du texte de recherche
      if (searchText.isNotEmpty) {
        List<String> results = [];
        if ('cours en ligne'.startsWith(searchText)) {
          results.add('Cours en ligne');
        }
        if ('cours à télécharger'.startsWith(searchText)) {
          results.add('Cours à télécharger');
        }
        if ('quiz'.startsWith(searchText)) {
          results.add('Quiz');
        }
        if ('tests'.startsWith(searchText)) {
          results.add('Tests');
        }
        if ('réclamation'.startsWith(searchText)) {
          results.add('Réclamation');
        }
        if ('chat'.startsWith(searchText)) {
          results.add('Chat');
        }

        if (results.isNotEmpty) {
          print('Résultats de recherche pour "$searchText": $results');
        } else {
          print('Aucun résultat trouvé pour "$searchText"');
        }
      } else {
        print('Aucune recherche effectuée');
      }
    }


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            "Profil",
            style: Theme.of(context).textTheme.headlineMedium!,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            ),
          ],
          backgroundColor: Colors.grey[200],
        ),
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
             //   crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Recherche',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        performSearch(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Action à effectuer pour le widget "Cours en ligne"
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                           Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.school, size: 50, color: Colors.blue),
    GestureDetector(
     
      onTap: () {
        Get.to(PdfViewer());
      },
      child: Text("Cours en ligne", textAlign: TextAlign.center),
    ),
  ],
),

                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FirstCoursesApp()),
                          );
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_download, size: 50, color: Colors.green),
                              GestureDetector(onTap: (){
                                Get.to(PdfTest());

                              },child:                              Text("Cours à télécharger", textAlign: TextAlign.center),),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizListScreen()),
                          );
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.quiz, size: 50, color: Colors.pinkAccent),
                              Text("Quiz", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(QuizListScreen());
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in, size: 50, color: Colors.red),
                              Text("Tests", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReclamationPage()),
                          );
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.report, size: 50, color: Colors.orange),
                              Text("Réclamation", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                     GestureDetector(
  onTap: () {
    Get.to(ChatbotScreen());
  },
  child: Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.chat, size: 50, color: Colors.purple),
        Text("Chat", textAlign: TextAlign.center),
      ],
    ),
  ),
),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
       
        
      
      bottomNavigationBar: BottomAppBar(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  // Action à effectuer pour l'accueil
                },
                child: Column(
                  children: [
                    Icon(Icons.home, color: Colors.blue),
                    Text('Accueil', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ModifierProfilPage()),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.edit, color: Colors.green),
                    Text('Modifier Profil', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                showLogoutDialog(context);
                },
                child: Column(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    Text('Déconnexion', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),),
    ));
  }
  
 void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
            Get.to(LoginScreen());
            },
          ),
        ],
      );
    },
  );
}

}


class ReclamationController extends GetxController {
  final TextEditingController categorieController = TextEditingController();
  final TextEditingController creatorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  Future<void> sendReclamation() async {
          LoginController login = Get.find(); // Get the instance of LoginController
    Future<String?> email=login.getuseremail();
    try {


      // Data to send
      Map<String, dynamic> data = {
        'categorie': categorieController.text,
        'creerpar': email.toString(),
        'description': descriptionController.text,
        'titre': titleController.text,
      };

      // Encode data to JSON
      String jsonData = json.encode(data);

      // Get authentication token
      String? authtoken = await login.gettoken();

      if (authtoken != null) {
        // Make POST request
        String apiUrl = 'http://192.168.1.17:8080/api/v1/auth/addReclamation';
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': '$authtoken',
          },
          body: jsonData,
        );

        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          Get.snackbar("Réclamations ajoutée avec succès", "Réclamations ajoutée avec succès");
          Get.to(ProfileScreen());
        } else {
          // Request failed
          print('Failed to send reclamation. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } else {
        // Handle case where token is null
        print('Token not found');
      }
    } catch (e) {
      // Handle exceptions
      print('Error sending reclamation: $e');
    }
  }
}


class ReclamationPage extends StatelessWidget {
  final ReclamationController reclamationController = Get.put(ReclamationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: reclamationController.categorieController,
              decoration: InputDecoration(labelText: 'Categorie'),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champs';
                      }
                      return ""; 
                    },
            
            ),
         
            TextFormField(
              controller: reclamationController.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
                 validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champs';
                      }
                      return null; 
                    },
            ),
            TextFormField(
              controller: reclamationController.titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champs';
                      }
                      return null; 
                    },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                reclamationController.sendReclamation();
              },
              child: Text('Send Reclamation'),
            ),
          ],
        ),
      ),
    );
  }
}
