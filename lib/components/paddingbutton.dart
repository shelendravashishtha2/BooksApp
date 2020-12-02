import 'package:flutter/material.dart';

class PaddingButtons extends StatelessWidget {

  final String text;
  final Function onpressed;

  PaddingButtons({@required this.text,this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.yellow[800],
      child: MaterialButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor:Colors.transparent ,
        onPressed:onpressed,
        child:Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:Color(0xFF344955),
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );
  }
}
