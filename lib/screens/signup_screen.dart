import 'package:codajoy/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  RegisterController registercontroller = Get.put(
    RegisterController()
  );
  // Text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final selectedniveauController = TextEditingController();
  // Options pour le champ de niveau

  // Form key for form validation
  final _formKey = GlobalKey<FormState>();

  // Sign user up method
  void signUserUp() {
    if (_formKey.currentState!.validate()) {
      registercontroller.register(emailController.text, usernameController.text ,confirmPasswordController.text, passwordController.text,selectedniveauController.text);
      // Ajoutez ici la logique pour enregistrer l'utilisateur dans la base de données ou effectuer d'autres opérations d'inscription
      print('Nom d\'utilisateur: ${usernameController.text}');
      print('Email: ${emailController.text}');
      print('Mot de passe: ${passwordController.text}');
      print('Confirmer mot de passe: ${confirmPasswordController.text}');
      print('Niveau: ${selectedniveauController.text}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    color: Colors.white, //
                    child: Image.asset(
                      'assets/images/logoo.png',
                      height: 200,width: 200,
                    ),
                  ),
                  const SizedBox(height: 10),


                  // Username textfield
                  _buildTextField(
                    controller: usernameController,
                    hintText: "Nom d'utilisateur",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre nom d\'utilisateur';
                      }
                      if(value.length<4){
                         return "La longueur de votre nom doit être supérieur à 4";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Email textfield
                  _buildTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre adresse e-mail';
                      
                      } else if (!value.endsWith('@gmail.com')) {
                        return 'Veuillez saisir une adresse  Gmail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Password textfield
                  _buildTextField(
                    controller: passwordController,
                    hintText: "Mot de passe",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre mot de passe';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Confirm password textfield
                  _buildTextField(
                    controller: confirmPasswordController,
                    hintText: "last name",
                    obscureText: false,
                  
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre prénom';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(height: 10),
                  // Dropdown pour le niveau
                  _buildTextField(
                    controller: selectedniveauController,
                    hintText: "Niveau",


                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner votre niveau';
                      }
                      return null;
                    },
                  ),

                  // Sign up button
                  const SizedBox(height: 25),
                  // Sign up button
                  ElevatedButton(
                    onPressed:(){

                      signUserUp();
                    },
                    child: Text("S'inscrire"),
                  ),
                  const SizedBox(height: 30),
                  // Already a member? Login
                  GestureDetector(
                    onTap: () {
                      // Navigation vers l'écran de connexion
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Déjà membre ?"),
                        SizedBox(width: 4),
                        Text(
                          "Connectez-vous",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fonction pour construire les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool readOnly = false,
    GestureTapCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher le menu déroulant du niveau
}


