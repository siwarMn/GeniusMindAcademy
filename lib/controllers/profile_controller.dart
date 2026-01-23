import 'dart:convert';
import 'package:codajoy/models/auth_models.dart';
import 'package:codajoy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart'; // import get
// import ProfileScreen
import 'package:codajoy/controllers/login_controller.dart'; // import LoginController
import 'package:codajoy/controllers/profile_menu_controller.dart'; // import ProfileMenuController

class ProfileController extends GetxController {
  AuthService authService = AuthService();

  // Storage
  final _storage = const FlutterSecureStorage();

  // User details controllers
  final TextEditingController nameController =
      TextEditingController(); // Maps to Lastname (Nom)
  final TextEditingController firstNameController =
      TextEditingController(); // Maps to Firstname (Prenom)
  final TextEditingController emailController = TextEditingController();

  // Password controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Image Selection
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxnString currentImageString = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    // Pre-fill controllers with current session data
    String? nom = await _storage.read(key: "nom");
    String? prenom = await _storage.read(key: "prenom");
    String? email = await _storage.read(key: "email") ??
        await _storage.read(key: "user_email");
    String? image = await _storage.read(key: "image");

    nameController.text = nom ?? "";
    firstNameController.text = prenom ?? "";
    emailController.text = email ?? "";
    currentImageString.value = image;
  }

  // Helper to read niveau
  Future<String?> _getNiveau() async {
    return await _storage.read(key: "niveau");
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  Future<void> updateFullProfile() async {
    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Show loading
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      print("Starting updateFullProfile...");

      // 1. Password Verification (if changing password)
      String passwordToSave = "";

      if (newPasswordController.text.isNotEmpty ||
          oldPasswordController.text.isNotEmpty) {
        if (oldPasswordController.text.isEmpty) {
          if (Get.isDialogOpen ?? false) Get.back(); // Close loading
          Get.snackbar("Erreur", "Veuillez entrer l'ancien mot de passe");
          return;
        }
        if (newPasswordController.text != confirmPasswordController.text) {
          if (Get.isDialogOpen ?? false) Get.back(); // Close loading
          Get.snackbar(
              "Erreur", "Les nouveaux mots de passe ne correspondent pas");
          return;
        }

        // Verify old password
        try {
          String? currentEmail = emailController.text;
          print("Verifying password for $currentEmail");
          await authService.authenticate(AuthenticationRequest(
              email: currentEmail, password: oldPasswordController.text));
          passwordToSave = newPasswordController.text;
        } catch (e) {
          print("Password verification failed: $e");
          if (Get.isDialogOpen ?? false) Get.back(); // Close loading
          Get.snackbar("Erreur", "Ancien mot de passe incorrect");
          return;
        }
      }

      // 2. Prepare Image
      String? encodedImage;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        encodedImage = base64Encode(bytes);
      }

      // 3. Construct Update Body
      String? niveau = await _getNiveau();
      print("Niveau retrieved: $niveau");

      Map<String, dynamic> updateBody = {
        'firstname': firstNameController.text,
        'lastname': nameController.text,
        'email': emailController.text,
        'niveau': niveau,
      };

      // Add password fields only if changing
      if (passwordToSave.isNotEmpty) {
        updateBody['oldPassword'] = oldPasswordController.text;
        updateBody['newPassword'] = newPasswordController.text;
        updateBody['confirmPassword'] = confirmPasswordController.text;
      }

      print("Sending updateProfile request...");
      await authService.updateProfile(updateBody, image: selectedImage.value);
      print("Update successful.");

      // 4. Update Local Storage
      await _storage.write(key: "nom", value: nameController.text);
      await _storage.write(key: "prenom", value: firstNameController.text);
      if (encodedImage != null) {
        await _storage.write(key: "image", value: encodedImage);
        currentImageString.value = encodedImage;
      }

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar("Succès", "Profil mis à jour",
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));

      // Wait a bit for snackbar then navigate back
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.of(Get.context!).pop(); // Safer than Get.back() sometimes

      if (Get.isRegistered<ProfileMenuController>()) {
        Get.find<ProfileMenuController>().onInit();
      }
    } catch (e) {
      print("Update Error: $e");
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading
      Get.snackbar("Erreur", "Mise à jour échouée: $e",
          duration: Duration(seconds: 5));
    }
  }

  Future<String?> getToken() async {
    LoginController login = Get.put(LoginController());
    return login.gettoken();
  }
}
