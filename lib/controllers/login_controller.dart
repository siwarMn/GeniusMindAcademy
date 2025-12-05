import 'package:codajoy/screens/components/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:codajoy/services/auth_service.dart';

class LoginController extends GetxController {
  AuthService authService = MockAuthService();

  Future<bool> signin(String email, String password, String niveau) async {
    try {
      final result = await authService.login(email, password);

      if (result['success'] == true) {
        String authtoken = result['token'];
        storeuseremail(email);
        await storetoken(authtoken);

        // Mocking token decoding slightly since we don't have a real JWT
        // Or we just skip the decoding part for mock
        // Map<String, dynamic> decodedToken = JwtDecoder.decode(authtoken!);
        // String emailfromtoken = decodedToken["sub"];

        Get.to(ProfileScreen());
        return true;
      } else {
        if (kDebugMode) {
          print(result['message']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return false;
    }
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
