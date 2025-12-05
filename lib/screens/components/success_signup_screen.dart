import 'package:flutter/material.dart';


class SuccessfulRegistrationPage extends StatelessWidget {
  const SuccessfulRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription Réussie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inscription Réussie'),
        ),
        body: SuccessfulRegistrationContent(),
      ),
    );
  }
}

class SuccessfulRegistrationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100.0,
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Félicitations, votre inscription est réussie!',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              // Action à effectuer lorsqu'on appuie sur le bouton
              // Par exemple, naviguer vers une autre page contenant les cours
            },
            child: Text('Voir les cours'),
          ),
        ],
      ),
    );
  }
}
