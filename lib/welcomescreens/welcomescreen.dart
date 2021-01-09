import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniproject/constants.dart';
import 'package:miniproject/welcomescreens/titlepage.dart';
import 'package:miniproject/welcomescreens/registration.dart';
import 'package:miniproject/welcomescreens/login.dart';

int pageNumber = 0;

final control = PageController(
  initialPage: pageNumber,
);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool> exit() async {
    return await showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.blueGrey.withOpacity(0.5),
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              bottom: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you want to exit the app",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                  // maxLines: 3,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 1,
                                  child: Divider(
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FlatButton(
                                      color: Colors.grey[200],
                                      padding: const EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        top: 10.0,
                                        bottom: 8.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.blueAccent,
                                      child: Text(
                                        'Cancel',
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      // Navigator.of(context).pop(false),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    FlatButton(
                                      color: Colors.grey[200],
                                      padding: const EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        top: 10.0,
                                        bottom: 8.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.blueAccent,
                                      child: Text(
                                        'Ok',
                                      ),
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        exit();
      },
      child: Scaffold(
        backgroundColor: kprimaryColor,
        body: SafeArea(
          child: PageView(
            controller: control,
            children: [
              PageViewOne(
                pageControl: control,
              ),
              PageTwo(),
              PageThree(),
            ],
          ),
        ),
      ),
    );
  }
}
