import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

final GlobalKey<FormState> _formMail1 = GlobalKey<FormState>();
final GlobalKey<FormState> _formPass1 = GlobalKey<FormState>();
final GlobalKey<FormState> _formPno = GlobalKey<FormState>();
final GlobalKey<FormState> _formName = GlobalKey<FormState>();

int count = 0;

class SignupState extends State<Signup> {
  var fs = FirebaseFirestore.instance;
  Position pos;
  String address, nickName, password2, pno = "";

  void initState() {
    super.initState();
    getPos();
  }

  Future<void> signUp() async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
          email: mail, password: password2);
      await auth.currentUser.sendEmailVerification();
      addUser(mail, nickName, pos.latitude, pos.longitude, pno, address);
      Navigator.pushReplacementNamed(context, '/verify');
    } catch (e) {
      print('fhdghdj');
      print(e.toString());
    }
  }

  getPos() async {
    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var adr = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(pos.latitude, pos.longitude));
    address = adr.first.addressLine;
    print(pos.longitude);
    print(pos.latitude);
  }

  void addUser(String mail, String n, double lat, double lon, String pno,
      String adr) async {
    await fs.collection('Sellers').doc(mail).set(
      {
        "Name": n,
        "Earnings": 0,
        "Coordinates": {'Latitude': lat, 'Longitude': lon},
        "Products": [],
        "Recieved Orders": {},
        "Requested Orders": {},
        "Accepted Orders": {},
        "Address": adr,
        "PNO": pno,
        "History": [],
        "Notifications": []
      },
    );
  }

  Widget buildPass() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formPass1,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            password2 = value;
          },
          validator: (value) =>
              value.length < 6 ? "Password should atleast 6 characters" : null,
        ),
      ),
    );
  }

  Widget buildPno() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formPno,
        child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              pno = value;
            },
            validator: (value) {
              if (!validatePno(value))
                return "Please enter valid Pno";
              else
                return null;
            }),
      ),
    );
  }

  Widget buildName() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formName,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Nick name',
            prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            nickName = value;
          },
        ),
      ),
    );
  }

  Widget buildEmail() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formMail1,
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

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: Container(
                  width: 280,
                  height: 450,
                  color: Colors.amber,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text("Signup",
                          style: TextStyle(color: Colors.blue, fontSize: 25)),
                      buildName(),
                      buildEmail(),
                      buildPass(),
                      buildPno(),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 90,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () async {
                              if (_formMail1.currentState.validate() &&
                                  _formPno.currentState.validate() &&
                                  _formPass1.currentState.validate()) {
                                signUp();
                              }
                            },
                            child:
                                Text("Signup", style: TextStyle(fontSize: 16)),
                            shape: RoundedRectangleBorder(),
                          )),
                    ],
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

bool validateEmail(val) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(val);
  return emailValid;
}

bool validatePno(val) {
  if (val.length != 10) return false;
  bool pnoVald = RegExp(r"^[0-9]").hasMatch(val);
  return pnoVald;
}
