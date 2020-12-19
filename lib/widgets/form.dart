import 'package:farmer/Screens/Orders/products.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

final _weightKey = GlobalKey<FormState>();
final _priceKey = GlobalKey<FormState>();
Position pos;

class FormAdd extends StatefulWidget {
  @override
  _FormAddState createState() => _FormAddState();
}

double wt, pr;

class _FormAddState extends State<FormAdd> {
  bool show = true;
  List<Widget> colWidgets = List();
  var fs = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    getPos();
  }

  getPos() async {
    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(pos.longitude);
    print(pos.latitude);
  }

  void addData(String mail) async {
    String id;
    var ref = await fs.collection('Products').doc(catagory).get();
    var refSel = await fs.collection('Sellers').doc(mail).get();
    var ar = refSel.data()['Products'];
    var notifications = refSel.data()['Notifications'];
    Prod prod =
        Prod(wt, pr, catagory, name, url, mail, pos.latitude, pos.longitude);
    await fs
        .collection("Items")
        .add(prod.getMap())
        .then((value) => id = value.id);
    ar.add(id);
    notifications.add({
      'Type': "Your products",
      'Disc': "Your product $name of $wt Kg is kept for sale for Rs $pr /Kg",
      'Time': DateTime.now().toString()
    });
    await fs
        .collection('Sellers')
        .doc(mail)
        .update({'Products': ar, 'Notifications': notifications});
    print(name);
    var p = ref.data()[name];
    var sellers = p["Sellers"] ?? [];
    sellers.add(id);
    fs.collection('Products').doc(catagory).set({
      ...ref.data(),
      name: {...p, "Sellers": sellers}
    });
  }

  Widget makeButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 200,
        child: FloatingActionButton(
          child: Text('Sell more items'),
          onPressed: () {
            colWidgets.clear();
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell your Product'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(url),
              if (show) buildInp('Weight', _weightKey),
              if (show) buildInpPrice('Price /kg', _priceKey),
              if (show)
                FloatingActionButton(
                  heroTag: '4',
                  child: Text('Sell'),
                  onPressed: () {
                    if (!(!_weightKey.currentState.validate() ||
                        !_priceKey.currentState.validate())) {
                      addData(mail);
                      colWidgets.add(Text('Your item is kept for sale'));
                      colWidgets.add(makeButton());
                      show = false;
                      setState(() {});
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: colWidgets,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInp(String name, GlobalKey<FormState> k) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Form(
      key: k,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: name,
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          wt = double.parse(value);
        },
        validator: (value) {
          return validDouble(value);
        },
      ),
    ),
  );
}

Widget buildInpPrice(String name, GlobalKey<FormState> k) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Form(
      key: k,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: name,
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          pr = double.parse(value);
        },
        validator: (value) {
          return validDouble(value);
        },
      ),
    ),
  );
}

String validDouble(value) {
  RegExp re = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
  if (re.hasMatch(value))
    return null;
  else {
    return "Please enter a valid number";
  }
}

class Prod {
  double weight;
  double price, lat, lon;
  String cat, product, imUrl, mail;
  Prod(this.weight, this.price, this.cat, this.product, this.imUrl, this.mail,
      this.lat, this.lon);
  Map<String, dynamic> getMap() {
    return {
      'Weight': weight,
      'Price': price,
      'Category': cat,
      'Name': product,
      'imUrl': imUrl,
      'seller': mail,
      'Position': {'Latitude': lat, 'Longitude': lon}
    };
  }
}
