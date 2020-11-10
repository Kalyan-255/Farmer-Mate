import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/main.dart';
import 'package:flutter/material.dart';
import 'Second.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

class _SecondState extends State<Second> {
  // ignore: non_constant_identifier_names
  List<Widget> wid_ar = List();
  @override
  void initState() {
    super.initState();
    if (Sellers != null && Sellers.length > 0) {
      print(Sellers);
      Sellers.forEach((e) {
        getSeller(e);
      });
    } else {
      wid_ar.add(Text(
          "Sorry currently no sellers are available for this product",
          style: TextStyle(color: Colors.white)));
    }
    setState(() {});
  }

  getDist(double lat, double lon) {
    var dis = Geolocator.distanceBetween(18.6577098, 77.8897229, lat, lon);
    return dp(dis * (1.609 / 1000), 2);
  }

  getSeller(String id) async {
    var seller = Map();
    var fs = FirebaseFirestore.instance;
    await fs
        .collection('Items')
        .doc(id)
        .get()
        .then((value) => value.data() != null
            ? value.data().forEach((key, value) {
                seller[key] = value;
              })
            : print('noData'));
    Widget x = makePost(seller, id);
    wid_ar.add(x);
    setState(() {});
    return seller;
  }

  Widget makePost(Map seller, String id) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserDetails(seller, id)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 280,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: NetworkImage(seller["imUrl"]),
                        fit: BoxFit.fill)),
                child: Stack(children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.add_shopping_cart, size: 30),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Color(0xff490b63).withOpacity(0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            seller["Weight"].toString() + " Kgs",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            seller["Price"].toString() + " Rs/Kg",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            getDist(seller["Position"]["Latitude"],
                                        seller["Position"]["Longitude"])
                                    .toString() +
                                " Km",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                          //Text(seller["seller"])
                        ],
                      ),
                    ),
                  ),
                ]),
              )),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Color(0xff490b63),
      ),
      body: Container(
        color: Color(0xff490b63),
        child: wid_ar.length == 0
            ? Center(
                child: Text("Loading your data hang on...",
                    style: TextStyle(color: Colors.white)))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: wid_ar.length,
                itemBuilder: (context, index) {
                  return wid_ar[index];
                },
              ),
      ),
    );
  }
}
