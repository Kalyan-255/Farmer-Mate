import 'package:farmer/Screens/Orders/RecievedOrders.dart';
import 'package:farmer/Screens/Orders/RequestedOrders.dart';
import 'package:farmer/widgets/ProductSlider.dart';
import 'package:farmer/widgets/speedDial2.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:farmer/widgets/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'widgets/form.dart';
import 'Screens/Orders/products.dart';
import 'package:farmer/Screens/buyer.dart';
import 'package:farmer/Screens/profile.dart';
import 'Screens/login.dart';

import 'widgets/routeAnimation.dart';

void main() async {
  GoogleMap.init('AIzaSyDCBKhLBuHhTwcBTufjAykyFBay8WILxmI');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/wrapper',
    routes: {
      '/home': (_) => MyHomePage(),
      '/second': (_) => Second(),
      '/Gmap': (_) => Gmap(),
      '/form': (_) => FormAdd(),
      '/products': (_) => MyProducts(),
      '/recieved': (_) => RecievedOrders(),
      '/requested': (_) => RequestedOrders(),
      '/profile': (_) => ProfilePage(),
      '/login': (_) => Log(),
      '/wrapper': (_) => Wrapper()
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
    );
  }
}

Map<String, dynamic> seller = Map();
String name = '', catagory = '', url = '', mail = "", nickName = '';
List yourProducts = List();
Map recievedOrders, requestedOrders, acceptedOrders = Map();
// ignore: non_constant_identifier_names
dynamic Sellers = List();
bool flag = true;

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var auth = FirebaseAuth.instance;
  int c = 0;
  dynamic ar = Map();
  var fruits = [];
  var vegetables = [];
  var kharif = [];
  var rabi = [];
  var types = ["Fruits", "Vegetables", "Kharif Cereals", "Rabi Cereals"];
  var fs = FirebaseFirestore.instance;
  List<Widget> wid = List();
  // ignore: non_constant_identifier_names
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      print("Working.....");
      mail = auth.currentUser.email;
    } else
      mail = "kalyanburriwar@gmail.com";
    setData();
    setState(() {});
  }

  setData() async {
    await getData("Fruits", fruits);
    await getData("Vegetables", vegetables);
    await getData("Kharif Cereals", kharif);
    await getData("Rabi Cereals", rabi);
    await getSeller(mail);
    requestedOrders = seller["Requested Orders"];
    acceptedOrders = seller["Accepted Orders"];
    recievedOrders = seller["Recieved Orders"];
    yourProducts = seller["Products"];
    nickName = seller["Name"];
  }

  getData(String category, List a) async {
    var ref = fs.collection("Products").doc(category);
    ref.get().then((value) {
      value.data().forEach((key, value) {
        var v = Map.from(value);
        a.add(v);
      });
      setState(() {});
    });
  }

  getSeller(String mail) async {
    await fs
        .collection('Sellers')
        .doc(mail)
        .get()
        .then((value) => value.data().forEach((key, value) {
              seller[key] = value;
            }));
  }

  void add(String mail, String n, double lat, double lon) {
    fs.collection('Sellers').doc(mail).set(
      {
        "Name": n,
        "Earnings": 0,
        "Coordinates": {'Latitude': lat, 'Longitude': lon},
        "Products": [],
        "Recieved Orders": []
      },
    );
  }

  buildHead(String h) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
      child: Text(
        h,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  makeGreeting() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello! " + nickName,
            style: TextStyle(
                fontFamily: 'PTSans',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              "Here are wide variety of products, you can sell or buy them by simply toggling the switch",
              style: TextStyle(fontFamily: 'PTSans', fontSize: 15))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Mate"),
        backgroundColor: flag ? Color(0xff490b63) : Color(0xff14cc73),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: 'a',
                  backgroundColor: flag ? Colors.redAccent : Colors.grey,
                  child: Text('Sell'),
                  onPressed: () {
                    flag = true;
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
                FloatingActionButton(
                  heroTag: 'b',
                  backgroundColor: flag ? Colors.grey : Colors.redAccent,
                  child: Text('Buy'),
                  onPressed: () {
                    flag = false;
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        makeGreeting(),
        buildHead("Fruits"),
        ProductSlider(fruits, "Fruits"),
        buildHead("Vegetables"),
        ProductSlider(vegetables, "Vegetables"),
        buildHead("Kharif"),
        ProductSlider(kharif, "Kharif Cereals"),
        buildHead("Rabi"),
        ProductSlider(rabi, "Rabi Cereals"),
      ]),
      floatingActionButton: flag ? Dial() : Dial2(),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class Gmap extends StatefulWidget {
  @override
  _GmapState createState() => _GmapState();
}

final GeoCoord b = GeoCoord(18.646200, 77.888199);

class _GmapState extends State<Gmap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialPosition: b,
      mapType: MapType.roadmap,
    );
  }
}
