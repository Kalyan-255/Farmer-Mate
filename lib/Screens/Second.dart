import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/Screens/Orders/RecievedOrders.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';

class UserDetails extends StatefulWidget {
  final String id;
  final Map prod;
  UserDetails(this.prod, this.id);
  @override
  _UserDetailsState createState() => _UserDetailsState(prod, id);
}

class _UserDetailsState extends State<UserDetails> {
  String id;
  Map prod;
  _UserDetailsState(this.prod, this.id);

  var seller;
  // ignore: non_constant_identifier_names
  var seller_recieved = Map();
  Map product = Map();
  List<Widget> wid = List();
  var fs = FirebaseFirestore.instance;

  requestProduct() async {
    seller_recieved.containsKey(id)
        ? seller_recieved[id].add(mail)
        : seller_recieved[id] = [mail];
    var sellerNotifications = seller["Notifications"];
    sellerNotifications.add({
      "Type": "Order recieved",
      "Disc": "You recieved an order on " +
          product['Name'] +
          " of " +
          product["Weight"].toString() +
          " Kg by buyer " +
          mail,
      "Time": DateTime.now().toString()
    });
    fs.collection("Sellers").doc(prod["seller"]).update({
      "Recieved Orders": seller_recieved,
      "Notifications": sellerNotifications
    });
    requestedOrders[id] = prod["seller"];
    fs
        .collection("Sellers")
        .doc(mail)
        .update({"Requested Orders": requestedOrders});
  }

  Future<List<Widget>> getSeller(String mail) async {
    wid.clear();
    await fs
        .collection("Sellers")
        .doc(prod["seller"])
        .get()
        .then((value) => seller = value.data());
    await fs
        .collection('Items')
        .doc(id)
        .get()
        .then((value) => value.data() != null
            ? value.data().forEach((key, value) {
                product[key] = value;
              })
            : print('noData'));
    seller_recieved = seller["Recieved Orders"];
    wid.add(Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 280,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: NetworkImage(prod["imUrl"]), fit: BoxFit.fill)),
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
                  prod["Weight"].toString() + " Kgs",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  prod["Price"].toString() + " Rs/Kg",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                // Text(
                //   getDist(seller["Position"]["Latitude"],
                //               seller["Position"]["Longitude"])
                //           .toString() +
                //       " Km",
                //   style:
                //       TextStyle(color: Colors.white, fontSize: 20),
                // )
                //Text(seller["seller"])
              ],
            ),
          ),
        ),
      ]),
    ));
    wid.add(Text("Seller : " + seller["Name"]));
    wid.add(Text("Coordinates : " + seller["Coordinates"].toString()));
    wid.add(Text("Address : " + seller["Address"]));
    print(id);
    print(wid.length);
    return wid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller Details"),
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            FutureBuilder(
              future: getSeller(prod["seller"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data,
                  );
                }
                return Center(child: Text("Loading Data"));
              },
            ),
            Positioned(
              bottom: 0,
              left: 100,
              child: SizedBox(
                width: 150,
                child: FloatingActionButton(
                  heroTag: 'a',
                  backgroundColor: Colors.redAccent,
                  child: Text('Request Order'),
                  onPressed: () {
                    requestProduct();
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
