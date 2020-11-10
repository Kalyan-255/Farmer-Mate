import 'package:farmer/Screens/Orders/RecievedOrders.dart';
import 'package:farmer/Screens/Orders/products.dart';
import 'package:farmer/Screens/profile.dart';
import 'package:farmer/widgets/routeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dial extends StatefulWidget {
  @override
  _DialState createState() => _DialState();
}

class _DialState extends State<Dial> {
  var auth = FirebaseAuth.instance;
  void logOut() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('loggedIn', false);
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      backgroundColor: Color(0xff2915ad),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.logout, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => logOut(),
          label: 'Logout',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.add_shopping_cart, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => Navigator.push(context, RouteAnimator(RecievedOrders())),
          label: 'Recieved Orders',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.shopping_bag, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => Navigator.push(context, RouteAnimator(MyProducts())),
          label: 'Your Products',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.person, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(context, RouteAnimator(ProfilePage()));
          },
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Profile'),
          ),
        ),
      ],
    );
  }
}
