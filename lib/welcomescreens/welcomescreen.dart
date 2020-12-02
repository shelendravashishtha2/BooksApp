import 'package:flutter/material.dart';
import 'package:miniproject/constants.dart';
import 'package:miniproject/welcomescreens/titlepage.dart';
import 'package:miniproject/welcomescreens/registration.dart';
import 'package:miniproject/welcomescreens/login.dart';

int pageNumber=0;

final control = PageController(
  initialPage: pageNumber,
);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColor,
      body: SafeArea(
        child: PageView(
          controller:control,
          children: [
            PageViewOne(pageControl: control,),
            PageTwo(),
            PageThree(),
          ],
        ),
      ),
    );
  }
}
