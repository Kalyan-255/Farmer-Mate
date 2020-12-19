import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOrders extends StatefulWidget {
  @override
  _AcceptedOrdersState createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  var fs = FirebaseFirestore.instance;
  var wid = [];
  del(String id) {
    fs.collection("Pending").doc(id).delete();
  }

  void initState() {
    super.initState();
    updateAccepted();
  }

  updateAccepted() async {
    await fs
        .collection("Sellers")
        .doc(mail)
        .get()
        .then((value) => acceptedOrders = value.data()["Accepted Orders"]);
    if (acceptedOrders.isEmpty)
      wid.add(Text(
        "Sorry you have no active accepted orders",
        style: TextStyle(color: Colors.white),
      ));
    acceptedOrders.forEach((key, element) {
      getOrder(key);
    });
    setState(() {});
  }

  getOrder(String key) async {
    var product = Map();
    await fs
        .collection("Pending")
        .doc(key)
        .get()
        .then((value) => product = value.data());
    wid.add(makePost(product, key));
    setState(() {});
  }

  delProd(String id, Map product) async {
    var sellerNotifications = [];
    del(id);
    acceptedOrders.remove(id);
    fs
        .collection("Sellers")
        .doc(mail)
        .update({"Accepted Orders": acceptedOrders});
    await fs
        .collection("Sellers")
        .doc(product['seller'])
        .get()
        .then((value) => sellerNotifications = value.data()["Notifications"]);
    sellerNotifications.add({
      "Type": "Order sent",
      "Disc": "Your" +
          product["Name"] +
          " of " +
          product['Weight'].toString() +
          "Kg sent to buyer " +
          mail +
          " successfully",
      "Time": DateTime.now().toString()
    });
    fs
        .collection("Sellers")
        .doc(product["seller"])
        .update({"Notifications": sellerNotifications});
  }

  Widget makePost(Map prod, String id) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Image.network(prod["imUrl"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Weight:" + prod["Weight"].toString()),
              Text("Price:" + prod["Price"].toString()),
              Text(prod["Name"])
            ],
          ),
          SizedBox(
            width: 200,
            child: FloatingActionButton(
              child: Text("Product Recieved"),
              onPressed: () => delProd(id, prod),
              shape: RoundedRectangleBorder(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accepted Orders"),
          backgroundColor: Color(0xff490b63),
        ),
        body: wid.length == 0
            ? Center(child: Text("Loading data"))
            : Stack(children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color(0xff490b63),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: wid.length,
                      itemBuilder: (context, index) {
                        return wid[index];
                      },
                    ),
                  ),
                ),
              ]),
        floatingActionButton: Dial());
  }
}
