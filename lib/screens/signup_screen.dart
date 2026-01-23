import 'dart:io';
import 'package:codajoy/controllers/register_controller.dart';
import 'package:codajoy/screens/login_screen.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final RegisterController registerController = Get.put(RegisterController());
  
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final niveauController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      registerController.register(
        _image,
        emailController.text,
        lastnameController.text, 
        firstnameController.text, 
        passwordController.text,
        niveauController.text,
      );
    }
  }

  ImageProvider? _getImageProvider() {
    if (_image == null) return null;
    if (kIsWeb) {
      return NetworkImage(_image!.path); // Blob URL on web
    } else {
      return FileImage(File(_image!.path)); // File path on mobile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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

                // Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.backgroundColor,
                      backgroundImage: _getImageProvider(),
                      child: _image == null
                          ? Icon(Icons.camera_alt, size: 40, color: AppTheme.textHint)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(child: Text("Ajouter une photo de profil", style: TextStyle(color: AppTheme.textSecondary))),

                const SizedBox(height: 20),

                // Firstname (Prénom)
                TextFormField(
                  controller: firstnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requit';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Prénom",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Lastname (Nom)
                TextFormField(
                  controller: lastnameController,
                  validator: (val) => val!.isEmpty ? 'Requit' : null,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    prefixIcon: Icon(Icons.badge_outlined),
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
