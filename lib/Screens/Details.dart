import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final String mail, id;
  UserDetails(this.mail, this.id);
  @override
  _UserDetailsState createState() => _UserDetailsState(mail, id);
}

class _UserDetailsState extends State<UserDetails> {
  String mail, id;
  _UserDetailsState(this.mail, this.id);

  var seller;
  Map product = Map();
  List<Widget> wid = List();
  var fs = FirebaseFirestore.instance;

  Future<List<Widget>> getSeller(String mail) async {
    await fs
        .collection("Sellers")
        .doc(mail)
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
    print(seller);
    wid.add(Image.network(product["imUrl"]));
    wid.add(Text("Name : " + seller["Name"]));
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
        child: FutureBuilder(
          future: getSeller(mail),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data,
              );
            }
            return Center(child: Text("Loading Data"));
          },
        ),
      ),
    );
  }
}
