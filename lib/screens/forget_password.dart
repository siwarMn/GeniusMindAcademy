import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
    child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/forgetPassword.jpg',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 20.0),
              Text(
                'Entrez votre adresse e-mail pour réinitialiser le mot de passe:',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight:FontWeight.bold),
                
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse e-mail';
                  }
                  if (!value.endsWith('@gmail.com')) {
                    return 'L\'adresse e-mail doit se terminer par "@gmail.com"';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.endsWith('@gmail.com')) {
                    // Envoyer l'e-mail de réinitialisation...
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('E-mail de réinitialisation envoyé à ${_emailController.text}', style: TextStyle(color: Colors.green),),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Veuillez entrer une adresse e-mail valide se terminant par "@gmail.com"'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Espacement interne
                  shape: RoundedRectangleBorder( // Bordure arrondie
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Envoyer l\'e-mail de réinitialisation'), // Texte du bouton
              ),

            ],
          ),
        ),
      ),
    ));
  }
}

