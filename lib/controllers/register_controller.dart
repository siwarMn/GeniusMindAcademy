import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:codajoy/services/auth_service.dart';

import '../screens/login_screen.dart';

class RegisterController extends GetxController {
  AuthService authService = MockAuthService();

  Future<bool> register(String email, String lastname, String name,
      String password, String niveau) async {
    try {
      final result = await authService.register(email, password, name);

      if (result['success'] == true) {
        Get.snackbar("Congrats!", "Registered");
        Get.to(LoginScreen());
        return true;
      } else {
        Get.snackbar("Sorry!", result['message'] ?? "Registration failed");
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }
}
