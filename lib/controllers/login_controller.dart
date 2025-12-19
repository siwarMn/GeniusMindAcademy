import 'package:codajoy/models/auth_models.dart';
import 'package:codajoy/screens/components/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:codajoy/services/auth_service.dart';
import 'package:codajoy/screens/login_screen.dart';

class LoginController extends GetxController {
  AuthService authService = AuthService();

  Future<bool> signin(String email, String password, String niveau) async {
    try {
      final request = AuthenticationRequest(email: email, password: password);
      final result = await authService.authenticate(request);

      if (result.token != null) {
        String authtoken = result.token!;
        await storetoken(authtoken);
        
        // Store user details
        if (result.nom != null) await _storage.write(key: "nom", value: result.nom);
        if (result.prenom != null) await _storage.write(key: "prenom", value: result.prenom);
        if (result.role != null) await _storage.write(key: "role", value: result.role);
        if (result.image != null) await _storage.write(key: "image", value: result.image);
        if (result.niveau != null) await _storage.write(key: "niveau", value: result.niveau);
        await storeuseremail(email);

        Get.to(ProfileScreen());
        return true;
      } else {
        Get.snackbar("Error", "No token received");
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      Get.snackbar("Error", "Login failed: ${e.toString()}");
      return false;
    }
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> logout() async {
    await _storage.deleteAll();
    Get.offAll(() => LoginScreen()); // Navigate to login and remove all previous routes
  }

  Future<void> storetoken(String? token) async {
    if (token != null) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(
        key: "token",
        value: token,
      );
    }
  }

  Future<String?> gettoken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return storage.read(
      key: "token",
    );
  }

  Future<void> storeuserid(String userid) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(
      key: "userid",
      value: userid,
    );
  }

  Future<String?> getuserid() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return storage.read(
      key: "userid",
    );
  }

  Future<void> storeuseremail(String email) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(
      key: "email",
      value: email,
    );
  }

  Future<String?> getuseremail() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return storage.read(
      key: "email",
    );
  }

  void navigatetocourses() {
    // Get.to(CoursesPage());
  }
}
