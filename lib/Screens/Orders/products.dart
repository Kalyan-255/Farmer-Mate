import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

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
      color: Colors.white,
      child: Column(
        children: [
          Image.network(seller["imUrl"]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                  seller["Name"],
                  style: TextStyle(
                      fontFamily: 'PTSans', fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Container(
            height: 20,
            color: Color(0xff490b63),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          backgroundColor: Color(0xff490b63),
        ),
        body: wid_ar.length == 0
            ? Center(child: Text("Loding data hang on..."))
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
                      itemCount: wid_ar.length,
                      itemBuilder: (context, index) {
                        return wid_ar[index];
                      },
                    ),
                  ),
                ),
              ]),
        floatingActionButton: Dial());
  }
}
