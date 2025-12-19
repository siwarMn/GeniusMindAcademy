import 'package:image_picker/image_picker.dart';
import 'package:codajoy/models/auth_models.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:codajoy/services/auth_service.dart';

import '../screens/login_screen.dart';

class RegisterController extends GetxController {
  AuthService authService = AuthService();

  Future<bool> register(
      XFile? image,
      String email,
      String lastname, 
      String firstname, 
      String password,
      String niveau) async {
    try {
      
      final request = RegisterRequest(
        firstname: firstname, 
        lastname: lastname,
        email: email,
        password: password,
        niveau: niveau,
        role: 'USER', // Default role
      );

      await authService.register(image, request);
      
      // If no exception, assume success
      Get.snackbar("Congrats!", "Registered successfully");
      Get.to(LoginScreen());
      return true;

    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Get.snackbar("Sorry!", "Registration failed: ${e.toString()}");
      return false;
    }
  }
}
