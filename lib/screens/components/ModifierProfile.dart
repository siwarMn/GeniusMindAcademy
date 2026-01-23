import 'dart:io';
import 'package:codajoy/controllers/profile_controller.dart';
import 'package:codajoy/utils/image_utils.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierProfilPage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Profil'),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo Header
              Obx(() {
                 ImageProvider? imageProvider;
                 
                 // 1. If user picked a new image, show it
                 if (profileController.selectedImage.value != null) {
                   if (kIsWeb) {
                     imageProvider = NetworkImage(profileController.selectedImage.value!.path);
                   } else {
                     imageProvider = FileImage(File(profileController.selectedImage.value!.path));
                   }
                 } 
                 // 2. If no new image, check for existing stored image string
                 else if (profileController.currentImageString.value != null && profileController.currentImageString.value!.isNotEmpty) {
                    try {
                       // Use ImageUtils to handle both Base64 and Java Arrays format
                       final decodedImage = ImageUtils.decodeImage(profileController.currentImageString.value!);
                       if (decodedImage != null) {
                         imageProvider = MemoryImage(decodedImage);
                       } else {
                         imageProvider = const AssetImage('assets/images/logoo.png');
                       }
                    } catch (e) {
                       // Fallback if decode fails
                       imageProvider = const AssetImage('assets/images/logoo.png');
                    }
                 } 
                 // 3. Fallback to default
                 else {
                   imageProvider = const AssetImage('assets/images/logoo.png');
                 }

                 return GestureDetector(
                  onTap: profileController.pickImage,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                          child: (profileController.selectedImage.value == null && profileController.currentImageString.value == null)
                              ? Icon(Icons.camera_alt, size: 40)
                              : null,
                        ),
                        Positioned(bottom: 0, right: 0, child: Icon(Icons.edit, color: Colors.blue))
                      ],
                    ),
                  ),
                );
              }),

              Text(
                'Informations personnelles',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              _buildTextField(profileController.nameController, 'Nom', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(profileController.firstNameController, 'Prénom', Icons.person_outline),
              const SizedBox(height: 15),
              _buildTextField(profileController.emailController, 'Email', Icons.email),
              
              const SizedBox(height: 30),
               Text(
                'Sécurité (Optionnel)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              _buildTextField(profileController.oldPasswordController, 'Ancien mot de passe', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 15),
              _buildTextField(profileController.newPasswordController, 'Nouveau mot de passe', Icons.lock, isPassword: true),
              const SizedBox(height: 15),
               _buildTextField(profileController.confirmPasswordController, 'Confirmer mot de passe', Icons.lock, isPassword: true),

               const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  profileController.updateFullProfile();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: Colors.blue, 
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Enregistrer les modifications', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      ),
    );
  }
}




