import 'package:codajoy/screens/components/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';

class LoginController extends GetxController {
  Future<bool> signin(String email, String password, String niveau) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      "email": email,
      "password": password,
      "niveau": niveau
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.17:8080/api/v1/auth/authenticate'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print(response.body);
        print(response.statusCode);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String? authtoken = responseBody["token"];
 Map<String, dynamic> decodedToken = JwtDecoder.decode(authtoken!);
        String emailfromtoken=decodedToken["sub"];
        storeuseremail(email);

        print(decodedToken);
        await storetoken(authtoken);

        // Navigate to profile screen
        Get.to(ProfileScreen());
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return false;
    }
    return false;
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
