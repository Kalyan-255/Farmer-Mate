import 'package:farmer/widgets/form.dart';
import 'package:farmer/widgets/routeAnimation.dart';
import 'package:flutter/material.dart';
import '../Screens/buyer.dart';
import '../main.dart';

class ProductSlider extends StatefulWidget {
  final Map mp;
  final String cat;
  ProductSlider(this.mp, this.cat);
  @override
  _ProductSliderState createState() => _ProductSliderState(mp, cat);
}

class _ProductSliderState extends State<ProductSlider> {
  Map mp;
  String cat;
  _ProductSliderState(this.mp, this.cat);
  @override
  Widget build(BuildContext context) {
    List keys = mp.keys.toList();
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mp.length,
        itemBuilder: (context, i) {
          return GestureDetector(
              onTap: () {
                name = mp[keys[i]]['Name'];
                url = mp[keys[i]]['Image'];
                catagory = cat;
                if (flag)
                  Navigator.push(context, RouteAnimator(FormAdd()));
                else {
                  print(mp[keys[i]]['Sellers']);
                  Sellers = mp[keys[i]]['Sellers'];
                  Navigator.push(context, RouteAnimator(Second()));
                }
              },
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      width: 160,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(mp[keys[i]]['Name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.network(mp[keys[i]]['Image']),
                        ],
                      )),
                ),
              ]));
        },
      ),
    );
  }
}
