import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';

class RequestedOrders extends StatefulWidget {
  @override
  _RequestedOrdersState createState() => _RequestedOrdersState();
}

class _RequestedOrdersState extends State<RequestedOrders> {
  var requestedOrd = [];
  var wid = [];
  var fs = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    setOrders();
    print(requestedOrd);
    setState(() {});
  }

  setOrders() async {
    await fs
        .collection("Sellers")
        .doc(mail)
        .get()
        .then((value) => requestedOrd = value.data()["Requested Orders"]);
    requestedOrd.forEach((element) {
      getProduct(element);
    });
    setState(() {});
  }

  getProduct(String id) async {
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
    Widget x = makePost(seller);
    wid.add(x);
    setState(() {});
  }

  Widget makePost(Map seller) {
    return Container(
      child: Column(
        children: [
          Image.network(seller["imUrl"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Weight:" + seller["Weight"].toString()),
              Text("Price:" + seller["Price"].toString()),
              Text(seller["Name"]),
            ],
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
        ),
        body: wid.length == 0
            ? Center(child: Text("Loading data"))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: wid.length,
                itemBuilder: (context, index) {
                  return wid[index];
                },
              ),
        floatingActionButton: Dial());
  }
}
