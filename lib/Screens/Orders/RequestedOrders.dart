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
    if (requestedOrders.isNotEmpty)
      setOrders();
    else
      wid.add(Text("You did not request any ordder"));
    setState(() {});
  }

  setOrders() async {
    requestedOrders.forEach((key, value) => getProduct(key));
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
      color: Colors.white,
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
                seller["Name"],
                style: TextStyle(
                    fontFamily: 'PTSans', fontWeight: FontWeight.w600),
              )
            ],
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
          title: Text("Requested Orders"),
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
