import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmer/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget makeTile(String name) {
    var dimen = MediaQuery.of(context).size;
    return Container(
      height: dimen.height * 0.08,
      width: dimen.width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(0.0, 10.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Center(
          child: Text(
        name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      )),
    );
  }

  Widget makeRow(String head, String cont, Icon ic) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            ic,
            SizedBox(
              width: 4,
            ),
            Text(
              head,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Text(cont,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xff490b63))),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var dimen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: dimen.height,
            width: dimen.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Color(0xffa6004d), Color(0xff280136)],
            )),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: dimen.height * 0.3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white),
              width: dimen.width * 0.97,
              height: dimen.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  makeRow("NUMBER", seller["PNO"],
                      Icon(Icons.phone, color: Color(0xff490b63))),
                  makeRow("ADDRESS", seller["Address"],
                      Icon(Icons.location_on, color: Color(0xff490b63))),
                  makeRow(
                      "EARNINGS",
                      seller["Earnings"].toString(),
                      Icon(CupertinoIcons.money_dollar_circle_fill,
                          color: Color(0xff490b63))),
                ],
              ),
            ),
          ),
          Positioned(
            top: dimen.height * 0.18,
            left: dimen.width * 0.05,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff490b63),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              height: 200,
              width: dimen.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                      child: Text(
                    seller["Name"],
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    overflow: TextOverflow.visible,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    mail,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: dimen.height * 0.07,
            left: dimen.width * 0.5 - 80,
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                    "https://pbs.twimg.com/profile_images/685700874434314240/80T5j3HF_400x400.jpg"),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
