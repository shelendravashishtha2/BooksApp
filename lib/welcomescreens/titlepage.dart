import 'package:flutter/material.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:miniproject/constants.dart';

class PageViewOne extends StatelessWidget {
  final PageController pageControl;

  PageViewOne({this.pageControl});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: (height / 4),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF344955),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            width: width,
            height: height,
          ),
        ),
        Positioned(
          top: (height / 2.5),
          left: width / 5,
          child: Text(
            'Find Your Favorite Books Here',
            style: TextStyle(
              fontFamily: 'Texturina',
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        Positioned(
          top: (height / 1.7),
          left: width / 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'An Android Application to \n Buy or Sell Books',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Texturina',
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Get Your Free Account Today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Texturina',
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: height - 150.0,
          left: width / 10,
          child: PaddingButtons(
            text: 'Log In',
            onpressed: () {
              pageControl.animateToPage(1,
                  duration: Duration(seconds: 1), curve: Curves.linear);
            },
          ),
        ),
        Positioned(
          top: height - 150.0,
          right: width / 10,
          child: PaddingButtons(
            text: 'Sign Up',
            onpressed: () {
              pageControl.animateToPage(2,
                  duration: Duration(seconds: 1), curve: Curves.linear);
            },
          ),
        ),
        Positioned(
          top: 0.0,
          height: (height / 4),
          child: Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
            ),
            width: width,
            height: height,
          ),
        ),
        Positioned(
          top: height / 10,
          left: width / 3,
          child: Material(
            borderRadius: BorderRadius.circular(width / 5),
            elevation: 10.0,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/hero_books_2019.png'),
              radius: width / 5,
            ),
          ),
        ),
      ],
    );
  }
}
