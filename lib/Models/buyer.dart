import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/main.dart';
import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  // ignore: non_constant_identifier_names
  List<Widget> wid_ar = List();
  @override
  void initState() {
    super.initState();
    print(Sellers);
    Sellers.forEach((e) {
      getSeller(e);
    });
    setState(() {});
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
                print(key);
              })
            : print('noData'));
    print(seller);
    Widget x = makePost(seller);
    wid_ar.add(x);
    setState(() {});
    return seller;
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
        title: Text('Second'),
      ),
      body: Container(
        child: ListView.builder(
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
