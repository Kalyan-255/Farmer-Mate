import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/Screens/Orders/RecievedOrders.dart';
import 'package:farmer/Screens/Orders/products.dart';
import 'package:farmer/main.dart';
import 'package:farmer/widgets/routeAnimation.dart';
import 'package:flutter/material.dart';

import 'Orders/acceptedOrders.dart';

class Notifications extends StatefulWidget {
  final List notifications;
  Notifications(this.notifications);
  @override
  _NotificationState createState() => _NotificationState(this.notifications);
}

class _NotificationState extends State<Notifications> {
  List notifications;
  var fs = FirebaseFirestore.instance;
  List<Widget> wid = List();
  _NotificationState(this.notifications);

  void initState() {
    super.initState();
  }

  makeList(List notif) {
    notif.forEach((element) {
      switch (element["Type"]) {
        case "Your products":
          wid.add(ListTile(
            tileColor: Colors.grey,
            title: Text(element["Type"] +
                "        " +
                element['Time'].substring(0, 16)),
            subtitle: Text(element["Disc"]),
            onTap: () => Navigator.push(context, RouteAnimator(MyProducts())),
          ));
          break;
        case "Order recieved":
          wid.add(ListTile(
            tileColor: Colors.red[300],
            title: Text(
                element["Type"] + "    " + element['Time'].substring(0, 16)),
            subtitle: Text(element["Disc"]),
            onTap: () =>
                Navigator.push(context, RouteAnimator(RecievedOrders())),
          ));
          break;
        case "Order accepted":
          wid.add(ListTile(
            tileColor: Colors.amber[300],
            title: Text(
                element["Type"] + "    " + element['Time'].substring(0, 16)),
            subtitle: Text(element["Disc"]),
            onTap: () =>
                Navigator.push(context, RouteAnimator(AcceptedOrders())),
          ));
          break;
        case "Order sent":
          wid.add(ListTile(
            tileColor: Colors.blue[300],
            title: Text(
                element["Type"] + "    " + element['Time'].substring(0, 16)),
            subtitle: Text(element["Disc"]),
            onTap: () => Navigator.push(context, RouteAnimator(MyHomePage())),
          ));
          break;
        default:
          wid.add(Text("Unknown"));
      }
    });
    return wid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color(0xff490b63),
      ),
      body: Container(
          child: StreamBuilder(
        stream: fs.collection("Sellers").doc(mail).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Text("Loading data");
          return ListView(
            children: makeList(snapshot.data["Notifications"]),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Text("clear"),
        backgroundColor: Colors.redAccent,
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () async {
          notifications.clear();
          wid.clear();
          await fs
              .collection("Sellers")
              .doc(mail)
              .update({"Notifications": []});
          setState(() {});
        },
      ),
    );
  }
}
