import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'widgets/form.dart';
import 'Models/products.dart';
import 'package:farmer/Models/buyer.dart';

void main() async {
  GoogleMap.init('AIzaSyDCBKhLBuHhTwcBTufjAykyFBay8WILxmI');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
    initialRoute: '/home',
    routes: {
      '/home': (_) => MyHomePage(),
      '/second': (_) => Second(),
      '/Gmap': (_) => Gmap(),
      '/form': (_) => FormAdd(),
      '/products': (_) => MyProducts()
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

String name = '', catagory = '', url = '', mail = "kalyanburriwar@gmail.com";
// ignore: non_constant_identifier_names
dynamic Sellers = List();
bool flag = true;

//GeoPoint g = GeoPoint(70, 70);
class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

Map<String, dynamic> seller = Map();

class MyHomePageState extends State<MyHomePage> {
  int c = 0;
  dynamic mp = List();
  var fs = FirebaseFirestore.instance;
  List<Widget> wid = List();
  // ignore: non_constant_identifier_names
  @override
  void initState() {
    super.initState();
    setCatagory("Fruits");
    setState(() {});
  }

  void setCatagory(String cat) async {
    mp.clear();
    setState(() {
      catagory = cat;
    });
    await fs
        .collection('Products')
        .doc(cat)
        .get()
        .then((value) => value.data().forEach((key, value) {
              mp.add(value);
            }));
    print(mp[0]['Name']);
    buildList();
  }

  getSeller(String mail) async {
    await fs
        .collection('Sellers')
        .doc(mail)
        .get()
        .then((value) => value.data().forEach((key, value) {
              seller[key] = value;
            }));
    return seller;
  }

  List<Widget> buildList() {
    wid.clear();
    int l = mp.length;
    for (int i = 0; i < l; i++) {
      wid.add(GestureDetector(
          onTap: () {
            name = mp[i]['Name'];
            url = mp[i]['Image'];
            if (flag)
              Navigator.pushNamed(context, '/form');
            else {
              Sellers = mp[i]['Sellers'];
              //getSeller(Sellers[0]);
              Navigator.pushNamed(context, '/second');
            }
          },
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  // color: Colors.white,
                  width: 260,
                  height: 330,
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
                      Text(mp[i]['Name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      Image.network(mp[i]['Image']),
                    ],
                  )),
            ),
          ])));
    }
    setState(() {});
    return wid;
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

  void addBuyer(String mail, String n, double lat, double lon) {
    fs.collection('Buyers').doc(mail).set(
      {
        "Name": n,
        "Amount": 0,
        "Coordinates": {'Latitude': lat, 'Longitude': lon},
        "Products History": [],
        "Recieved Orders": []
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget build_but(String cat, String n) {
    return FloatingActionButton(
        backgroundColor: catagory == cat ? Colors.red : Colors.blue,
        heroTag: cat[0],
        child: Text(n),
        onPressed: () => setCatagory(cat),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Mate"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: 'a',
                  backgroundColor: flag ? Colors.green : Colors.grey,
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
                  backgroundColor: flag ? Colors.grey : Colors.green,
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
      body: Container(
        color: Colors.blue[100],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: build_but("Fruits", "Fruits"),
                ),
                SizedBox(
                  width: 90,
                  child: build_but("Vegetables", "Vegetables"),
                ),
                build_but("Kharif Cereals", "Kharif"),
                build_but("Rabi Cereals", "Rabi"),
                FloatingActionButton(
                  heroTag: '5',
                  child: Text('test'),
                  onPressed: () => Navigator.pushNamed(context, '/products'),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: wid.length,
              itemBuilder: (context, index) {
                return wid[index];
              },
            )),
          ],
        ),
      ),
      floatingActionButton: Dial(),
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
