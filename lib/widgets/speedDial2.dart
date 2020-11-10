import 'package:farmer/Screens/Orders/RequestedOrders.dart';
import 'package:farmer/Screens/Orders/acceptedOrders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:farmer/Screens/profile.dart';
import 'package:farmer/widgets/routeAnimation.dart';

class Dial2 extends StatefulWidget {
  @override
  _DialState2 createState() => _DialState2();
}

class _DialState2 extends State<Dial2> {
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
          child: Icon(Icons.add_shopping_cart, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => Navigator.push(context, RouteAnimator(AcceptedOrders())),
          label: 'Accepted Orders',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.shopping_bag, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () =>
              Navigator.push(context, RouteAnimator(RequestedOrders())),
          label: 'Requested Orders',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.person, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => Navigator.push(context, RouteAnimator(ProfilePage())),
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
