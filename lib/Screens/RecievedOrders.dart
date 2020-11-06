import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';

class RecievedOrders extends StatefulWidget {
  @override
  _RecievedOrdersState createState() => _RecievedOrdersState();
}

class _RecievedOrdersState extends State<RecievedOrders> {
  var recievedOrd = [];
  var wid = [];
  var fs = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    setOrders();
    print(recievedOrd);
    setState(() {});
  }

  setOrders() async {
    await fs
        .collection("Sellers")
        .doc(mail)
        .get()
        .then((value) => recievedOrd = value.data()["Recieved Orders"]);
    recievedOrd.forEach((element) {
      getProduct(element["Product"], element["Buyer"]);
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
    Widget x = makePost(seller, buyer);
    wid.add(x);
    setState(() {});
  }

  Widget makePost(Map seller, String buyer) {
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
              Text(buyer),
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
            ? Center(
                child: Text("Loading Data"),
              )
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
