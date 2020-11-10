import 'package:flutter/material.dart';
import 'package:farmer/main.dart';
import 'package:farmer/widgets/routeAnimation.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Log extends StatefulWidget {
  State<StatefulWidget> createState() {
    return LogState();
  }
}

final GlobalKey<FormState> _formMail = GlobalKey<FormState>();
final GlobalKey<FormState> _formPass = GlobalKey<FormState>();
int count = 0;

class LogState extends State<Log> {
  Future<void> signIn() async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: mail, password: password);
      var pref = await SharedPreferences.getInstance();
      pref.setBool('loggedIn', true);
      print(pref.getBool('loggedIn'));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print(e.message);
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 280,
                    height: 400,
                    color: Colors.amber.withOpacity(0.8),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text("Login",
                            style: TextStyle(color: Colors.blue, fontSize: 25)),
                        buildEmail(),
                        buildPass(),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 90,
                            height: 50,
                            child: FloatingActionButton(
                              heroTag: '2',
                              onPressed: () async {
                                if (_formMail.currentState.validate()) {
                                  signIn();
                                }
                              },
                              backgroundColor: Colors.redAccent,
                              focusColor: Colors.deepOrangeAccent,
                              child: Text('Signin',
                                  style: TextStyle(fontSize: 17)),
                              shape: RoundedRectangleBorder(),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text("don't have an account?"),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 90,
                            height: 50,
                            child: FloatingActionButton(
                              onPressed: () async {
                                Navigator.pushReplacement(
                                    context, RouteAnimator(Signup()));
                              },
                              child: Text("Signup",
                                  style: TextStyle(fontSize: 16)),
                              shape: RoundedRectangleBorder(),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String password = "";

// int validateUser(val) {
//   int x = DatabaseHelper.instance.findName(val).then((value) {
//     return value;
//     }
//   );
//   return x;
// }

Widget buildEmail() {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Form(
      key: _formMail,
      child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            mail = value;
          },
          validator: (value) {
            if (!validateEmail(value))
              return "Please enter valid mail id";
            else
              return null;
          }),
    ),
  );
}

bool validateEmail(val) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(val);
  return emailValid;
}

Widget buildPass() {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Form(
      key: _formPass,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          password = value;
        },
      ),
    ),
  );
}
