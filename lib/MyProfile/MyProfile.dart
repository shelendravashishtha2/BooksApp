import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:miniproject/constants.dart';

class MyProfile extends StatefulWidget {
  final userName;
  final userImage;
  MyProfile({this.userImage, this.userName});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<dynamic> userDetails = [];
  int soldBooks;
  int boughtBooks;

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  makeRequest() async {
    Response response = await get(
        'https://miniproject132.pythonanywhere.com/api/user/${FirebaseAuth.instance.currentUser.email}/',
        headers: {
          "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1"
        });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      for (int i = 0; i < res.length; i++) {
        setState(() {
          userDetails.add(res["user_mail"]);
          userDetails.add(res["contact_number"]);
          userDetails.add(res["roll_no"]);
        });
      }
      print(userDetails);
    }

    Response resp = await get(
        'https://miniproject132.pythonanywhere.com/api/book?sold_by=${FirebaseAuth.instance.currentUser.email}',
        headers: {
          "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1"
        });
    setState(() {
      if (resp.statusCode == 200) {
        var res = jsonDecode(resp.body);
        soldBooks = res.length;
      }
    });

    Response res = await get(
        'https://miniproject132.pythonanywhere.com/api/book?bought_by=${FirebaseAuth.instance.currentUser.email}',
        headers: {
          "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1"
        });
    setState(() {
      if (resp.statusCode == 200) {
        var resp = jsonDecode(res.body);
        boughtBooks = resp.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kprimaryColor,
      body:
          (userDetails.length == 0 || boughtBooks == null || soldBooks == null)
              ? Center(
                  child: SpinKitFadingCube(
                    color: Colors.white,
                    size: 18.0,
                  ),
                )
              : Builder(
                  builder: (context) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              color: Color(0xFF344955),
                              height: height / 5,
                            ),
                            Positioned(
                              top: 40.0,
                              left: 10.0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              left: width / 2 - 60.0,
                              height: height / 4 + 120.0,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundColor: Colors.yellow.shade200,
                                child: CircleAvatar(
                                  radius: 58.0,
                                  backgroundColor: kprimaryColor,
                                  child: Material(
                                    elevation: 7.0,
                                    borderRadius: BorderRadius.circular(54.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 54.0,
                                      backgroundImage: NetworkImage(
                                        widget.userImage,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.userName,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              tileColor: Color(0xFF344955),
                              leading: Icon(Icons.email),
                              title: Text(userDetails[0]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.0,
                          child: Divider(
                            color: Colors.grey[150],
                          ),
                        ),
                        ListTile(
                          tileColor: Color(0xFF344955),
                          leading: Icon(Icons.phone),
                          title: Text(userDetails[1].toString()),
                        ),
                        SizedBox(
                          height: 1.0,
                          child: Divider(
                            color: Colors.grey[150],
                          ),
                        ),
                        ListTile(
                          tileColor: Color(0xFF344955),
                          leading: Icon(Icons.backpack_rounded),
                          title: Text(userDetails[2].toString()),
                        ),
                        SizedBox(
                          height: 1.0,
                          child: Divider(
                            color: Colors.grey[150],
                          ),
                        ),
                        ListTile(
                          tileColor: Color(0xFF344955),
                          leading: Icon(CupertinoIcons.upload_circle),
                          title: Text('Books Uploaded'),
                          trailing: Text(soldBooks.toString()),
                        ),
                        SizedBox(
                          height: 1.0,
                          child: Divider(
                            color: Colors.grey[150],
                          ),
                        ),
                        ListTile(
                          tileColor: Color(0xFF344955),
                          leading: Icon(CupertinoIcons.bookmark),
                          title: Text('Books Bought'),
                          trailing: Text(boughtBooks.toString()),
                        ),
                        SizedBox(
                          height: 1.0,
                          child: Divider(
                            color: Colors.grey[150],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 190.0,
                                child: PieChart(
                                  PieChartData(
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sections: [
                                      PieChartSectionData(
                                        color: Colors.lightBlueAccent,
                                        value: soldBooks.toDouble(),
                                        title: 'Uploads',
                                      ),
                                      PieChartSectionData(
                                        color: Colors.redAccent,
                                        value: boughtBooks.toDouble(),
                                        title: 'Buys',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
