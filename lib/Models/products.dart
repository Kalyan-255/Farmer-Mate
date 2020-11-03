import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MyProducts extends StatefulWidget {
  @override
  MyProductsState createState() => MyProductsState();
}

class MyProductsState extends State<MyProducts> {
  var products = [];
  // ignore: non_constant_identifier_names
  var wid_ar = [];
  var fs = FirebaseFirestore.instance;
  void initState() {
    super.initState();
    setProducts();
  }

  void setProducts() async {
    products = await fs
        .collection("Sellers")
        .doc(mail)
        .get()
        .then((value) => products = value.data()["Products"]);
    print(products);
    products.forEach((element) {
      getSeller(element);
    });
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
    Widget x = makePost(seller);
    wid_ar.add(x);
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
              Text(seller["Name"])
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
          title: Text("Your Products"),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: wid_ar.length,
          itemBuilder: (context, index) {
            return wid_ar[index];
          },
        ),
        floatingActionButton: Dial());
  }
}
