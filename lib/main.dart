import 'package:farmer/Screens/Orders/RecievedOrders.dart';
import 'package:farmer/Screens/Orders/RequestedOrders.dart';
import 'package:farmer/widgets/EmailVerification.dart';
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
import 'Screens/Notifications.dart';
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
      '/wrapper': (_) => Wrapper(),
      '/verify': (_) => Verify()
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
  var fs = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      mail = auth.currentUser.email;
    } else
      mail = "kalyanburriwar@gmail.com";
    setData();
    setState(() {});
  }

  Future<void> setData() async {
    await getSeller(mail);
    requestedOrders = seller["Requested Orders"];
    acceptedOrders = seller["Accepted Orders"];
    recievedOrders = seller["Recieved Orders"];
    yourProducts = seller["Products"];
    nickName = seller["Name"];
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

  makeStream(int i, String cat) {
    return StreamBuilder(
      stream: fs.collection("Products").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data != null) {
          var mp = snapshot.data.docs[i].data();
          List keys = mp.keys.toList();
          return Container(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mp.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                    onTap: () {
                      name = mp[keys[i]]['Name'];
                      url = mp[keys[i]]['Image'];
                      catagory = cat;
                      if (flag)
                        Navigator.push(context, RouteAnimator(FormAdd()));
                      else {
                        print(mp[keys[i]]['Sellers']);
                        Sellers = mp[keys[i]]['Sellers'];
                        Navigator.push(context, RouteAnimator(Second()));
                      }
                    },
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            width: 160,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0.0, 10.0),
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(mp[keys[i]]['Name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Image.network(mp[keys[i]]['Image']),
                              ],
                            )),
                      ),
                    ]));
              },
            ),
          );
        }
        return Text("Loading...");
      },
    );
  }

  notificationStream() {
    return StreamBuilder(
      stream: fs.collection("Sellers").doc(mail).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data["Notifications"].length > 0) {
            return Stack(children: [
              IconButton(
                  icon: Icon(Icons.notifications_sharp,
                      size: 36, color: Colors.white),
                  onPressed: () => Navigator.push(
                      context,
                      RouteAnimator(
                          Notifications(snapshot.data["Notifications"])))),
              Positioned(
                  right: 9,
                  top: 15,
                  child: Icon(
                    Icons.circle,
                    size: 12,
                    color: Colors.redAccent,
                  ))
            ]);
          }
        }
        var mp = [];
        return IconButton(
            icon:
                Icon(Icons.notifications_sharp, size: 36, color: Colors.white),
            onPressed: () =>
                Navigator.push(context, RouteAnimator(Notifications(mp))));
      },
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
            padding: const EdgeInsets.all(8.0),
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
          SizedBox(
            width: 10,
          ),
          notificationStream(),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        makeGreeting(),
        buildHead("Fruits"),
        makeStream(0, "Fruits"),
        buildHead("Vegetables"),
        makeStream(3, "Vegetables"),
        buildHead("Kharif"),
        makeStream(1, "Kharif Cereals"),
        buildHead("Rabi"),
        makeStream(2, "Rabi Cereals"),
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
