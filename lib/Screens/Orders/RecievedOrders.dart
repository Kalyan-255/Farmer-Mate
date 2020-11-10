import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/Screens/Orders/acceptedOrders.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';

class RecievedOrders extends StatefulWidget {
  @override
  _RecievedOrdersState createState() => _RecievedOrdersState();
}

class _RecievedOrdersState extends State<RecievedOrders> {
  var recievedOrd = Map();
  var wid = [];
  var fs = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    if (recievedOrders.isNotEmpty)
      setOrders();
    else
      wid.add(Text("You did not recieved any orders"));
    print(recievedOrd);
    setState(() {});
  }

  setOrders() async {
    recievedOrders.forEach((key, element) {
      getProduct(key, element);
    });
    setState(() {});
  }

  getProduct(String id, String buyer) async {
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
    Widget x = makePost(id, seller, buyer);
    wid.add(x);
    setState(() {});
  }

  acceptOrder(String id, String buyer, String nm, String ct) async {
    Map byr = Map();
    await fs
        .collection("Sellers")
        .doc(buyer)
        .get()
        .then((value) => byr = value.data());
    recievedOrders.remove(id);
    yourProducts.remove(id);
    byr["Requested Orders"].remove(id);
    byr["Accepted Orders"][id] = mail;
    fs
        .collection("Sellers")
        .doc(mail)
        .update({"Recieved Orders": recievedOrders, "Products": yourProducts});
    fs.collection("Sellers").doc(buyer).update({
      "Requested Orders": byr["Requested Orders"],
      "Accepted Orders": byr["Accepted Orders"]
    });
    /////
    var x = Map();
    await fs
        .collection("Products")
        .doc(ct)
        .get()
        .then((value) => x = value.data()[nm]);
    x["Sellers"].remove(id);
    fs.collection("Products").doc(ct).update({nm: x});
    ////////
    var y;
    await fs
        .collection("Items")
        .doc(id)
        .get()
        .then((value) => y = value.data());
    fs.collection("Items").doc(id).delete();
    fs.collection("Pending").doc(id).set(y);
  }

  Widget makePost(String id, Map seller, String buyer) {
    return Container(
      child: Column(
        children: [
          Image.network(seller["imUrl"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                seller["Weight"].toString() + " Kgs",
                style: TextStyle(
                    fontFamily: 'PTSans', fontWeight: FontWeight.w600),
              ),
              Text(
                seller["Price"].toString() + " Rs/Kg",
                style: TextStyle(
                    fontFamily: 'PTSans', fontWeight: FontWeight.w600),
              ),
              Text(
                buyer,
                style: TextStyle(
                    fontFamily: 'PTSans', fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 150,
            child: FloatingActionButton(
              child: Text("Accept"),
              shape: RoundedRectangleBorder(),
              onPressed: () =>
                  acceptOrder(id, buyer, seller["Name"], seller["Category"]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recieved Orders"),
          backgroundColor: Color(0xff490b63),
        ),
        body: wid.length == 0
            ? Center(
                child: Text("Loading Data"),
              )
            : Stack(children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color(0xff490b63),
                ),
                Center(
                  child: Container(
                    color: Colors.white,
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
