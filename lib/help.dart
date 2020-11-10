import 'package:cloud_firestore/cloud_firestore.dart';

var fs = FirebaseFirestore.instance;

void add(String mail, String n, String pno, String branch, String year) {
  fs.collection('Users').doc(mail).set(
    {
      "Name": n,
      "PNO": pno,
      "Branch": branch,
      "Year": year,
      "Products": [],
      "Recieved Orders": []
    },
  );
}

Future<Map<String, dynamic>> getSeller(String id) async {
  String mail;
  await fs
      .collection("Products")
      .doc(id)
      .get()
      .then((value) => mail = value.data()['Seller']);
  var mp = Map();
  await fs
      .collection("Users")
      .doc(mail)
      .get()
      .then((value) => value.data().forEach((key, value) {
            mp[key] = value;
          }));
  return mp;
}

void addPoduct(String name, String url, double price, String cat, String mail) {
  String y;
  Map<String, dynamic> mp;
  fs.collection("Products").add({"Name": name}).then((value) => y = value.id);
  fs
      .collection("Users")
      .doc(mail)
      .get()
      .then((value) => value.data().forEach((key, value) {
            mp[key] = value;
          }));
  var prod = mp["Products"];
  prod.add(y);
  fs.collection("Users").doc(mail).update({'Products': prod});
  fs.collection("Catagories").doc(cat).set({mail + name: y});
}

void addBuyer(
    String mail, String n, double lat, double lon, String pno, String adr) {
  fs.collection('Sellers').doc(mail).set(
    {
      "Name": n,
      "Earnings": 0,
      "Coordinates": {'Latitude': lat, 'Longitude': lon},
      "Products": [],
      "Recieved Orders": {},
      "Requested Orders": {},
      "Accepted Orders": {},
      "Address": adr
    },
  );
}
