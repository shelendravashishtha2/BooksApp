import 'package:flutter/material.dart';
import 'package:miniproject/components/paddingbutton.dart';

class PageViewOne extends StatelessWidget {

  final PageController pageControl;

  PageViewOne({this.pageControl});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              'Books',
              style:TextStyle(
                color:Colors.white,
                fontSize: 30.0,
                fontFamily: 'yellowtailregular',
              ),
            ),
          ),
          Expanded(
            child:Padding(
              padding: EdgeInsets.all(15.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                elevation: 10.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    'images/hero_books_2019.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top:8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Color(0xFF344955),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          'Find Your Favorite Books Here',
                          style: TextStyle(
                            fontFamily: 'Texturina',
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'An Android Application to \n Buy or Sell Books',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Texturina',
                              fontSize: 16.0,
                              color:Colors.white70,
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
                              color:Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PaddingButtons(
                          text:'Sign Up',
                          onpressed: (){
                            pageControl.animateToPage(2, duration: Duration(seconds:1), curve: Curves.linear);
                          },
                        ),
                        PaddingButtons(
                          text:'LogIn',
                          onpressed: (){
                            pageControl.animateToPage(1, duration: Duration(milliseconds:500), curve: Curves.linear);
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
    );
  }
}
