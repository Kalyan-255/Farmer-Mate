import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool fl = false;
  void initState() {
    super.initState();
    check();
  }

  void check() async {
    var pref = await SharedPreferences.getInstance();
    fl = pref.getBool('loggedIn') ?? false;
    fl
        ? Navigator.pushReplacementNamed(context, '/home')
        : Navigator.pushReplacementNamed(context, '/login');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
              child: Icon(
            Icons.home,
            size: 100,
            color: Color(0xff490b63),
          )),
        ),
      ),
    );
  }
}
