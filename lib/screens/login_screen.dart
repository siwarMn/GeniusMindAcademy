import 'package:codajoy/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:codajoy/screens/components/my_button.dart';
import 'package:codajoy/screens/signup_screen.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  LoginController login = Get.put(LoginController());
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final niveauController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Sign user in method
  void SignUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Expanded(
            child: Center(
              child: Expanded(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 40, right: 40, top: 50),
                        child: Text(
                          "Nous sommes si heureux\n de vous revoir !",
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 1.1,
                          heightFactor: 2,
                          child: Image.asset("assets/images/boy.png"),
                        ),
                      ),

                      // Username textfield
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: usernameController,
                          //
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre adresse e-mail';
                            } else if (!RegExp(
                                    r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])*$")
                                .hasMatch(value)) {
                              return 'Veuillez saisir une adresse e-mail valide';
                            } else if (!value.endsWith('@gmail.com')) {
                              return 'Veuillez saisir une adresse  Gmail';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Adresse Email",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Adjust border color here
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(Icons.email)),
                        ),
                      ),

                      // Username textfield
                      Padding(
                        padding: EdgeInsets.all(20),
                        child:
                            // Password textfield
                            TextFormField(
                          controller: passwordController,
                          //    hintText: "Mot de passe",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe';
                            } else if (!RegExp(
                                    r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$')
                                .hasMatch(value)) {
                              return 'Le mot de passe doit contenir au moins 6 caractères, une lettre majuscule, un chiffre et un caractère spécial';
                            }
                            return "";
                          },
                          decoration: InputDecoration(
                              hintText: "Mot de passe",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Adjust border color here
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(Icons.password)),
                        ),
                      ),

                      // Mot de passe oublié

                      // Sign in button
                      MyButton(
                        onTap: () {
                          login.signin(usernameController.text,
                              passwordController.text, niveauController.text);
                        },
                        buttonText: "connexion".capitalize!,
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              // Not a member? signup
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen())); // Navigation vers la page signup_screen.dart
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Pas encore membre ?"),
                                    SizedBox(width: 4),
                                    Text(
                                      "Inscrivez-vous",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              // Not a member? signup
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
