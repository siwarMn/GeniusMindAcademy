import 'package:codajoy/controllers/register_controller.dart';
import 'package:codajoy/screens/login_screen.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final RegisterController registerController = Get.put(RegisterController());

  // Controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final niveauController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      registerController.register(
        emailController.text,
        usernameController.text,
        confirmPasswordController
            .text, // Assuming this maps to name/lastname as per controller
        passwordController.text,
        niveauController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Créer un compte",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Rejoignez-nous pour commencer votre apprentissage!",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Image (Optional, keeping consistent with old design if wanted, or smaller)
                // SizedBox(height: 100, child: Image.asset('assets/images/logoo.png')),

                const SizedBox(height: 20),

                // Username
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requit';
                    if (value.length < 4) return 'Min 4 caractères';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Nom d'utilisateur",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requit';
                    if (!GetUtils.isEmail(value)) return 'Email invalide';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requit';
                    if (value.length < 6) return 'Min 6 caractères';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Mot de passe",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password (used as 'last name' or 'first name' in old controller?? - reusing standard field)
                // The old controller parameters were: email, lastname, name, password, niveau
                // In the old UI:
                // usernameController -> "Nom d'utilisateur"
                // confirmPasswordController -> "Last Name" (Hint says "last name", validator "prénom") - this is confusing in old code.
                // Let's assume confirmPasswordController is meant to be Name or generic. I'll relabel it "Prénom / Nom"
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (val) => val!.isEmpty ? 'Requit' : null,
                  decoration: const InputDecoration(
                    labelText: "Prénom / Nom",
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Niveau
                TextFormField(
                  controller: niveauController,
                  validator: (val) => val!.isEmpty ? 'Requit' : null,
                  decoration: const InputDecoration(
                    labelText: "Niveau",
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    child: const Text("S'INSCRIRE"),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Déjà membre?"),
                    TextButton(
                      onPressed: () => Get.back(), // Go back to login
                      child: const Text(
                        "Connectez-vous",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
