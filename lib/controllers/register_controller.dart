import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../screens/login_screen.dart';


class RegisterController extends GetxController {

  Future<bool> register(String email,String lastname, String name, String password,String niveau) async {
    try {

      Map<String, String> headers = {'Content-Type': 'application/json'};

      Map<String, String> body = {"firstname": name, "lastname": lastname, "email": email,"password":password,"niveau":niveau,};
      if (kDebugMode) {
        print(body);
      }

      final response = await http.post(
        Uri.parse('http://192.168.1.17:8080/api/v1/auth/register'),
        headers: headers,
        body: jsonEncode(body),
      );
print(response.statusCode);
      // ignore: unnecessary_null_comparison
      if (response == null) {
        if (kDebugMode) {
          print('Error: HTTP response is null.');
        }
        return false;
      }


      if (response.statusCode == 200) {
         Get.snackbar("Congrats!", "Registered");
       
        Get.to(LoginScreen());
        return true;
      } else {

         Get.snackbar("Sorry!", "User already exists");
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
