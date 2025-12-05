import 'package:codajoy/screens/login_screen.dart';
import 'package:flutter/material.dart';
class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {

              _logout(context);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
            ),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
