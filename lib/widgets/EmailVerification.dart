import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  var auth = FirebaseAuth.instance;

  void check() async {
    await auth.currentUser.reload();
    if (auth.currentUser.emailVerified) {
      var pref = await SharedPreferences.getInstance();
      pref.setBool('loggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("A verification link is sent to your email"),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(),
                  child: Text("Email Verified"),
                  onPressed: () => check(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
