import 'package:flutter/material.dart';

Color kprimaryColor = Color(0xFF4A6572);

final kInputDecoration = InputDecoration(
    prefixIcon: null,
    filled: true,
    fillColor: Color(0xFF344955),
    labelText: 'Enter Your Email',
    labelStyle: TextStyle(
      color:Colors.white70,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Color(0xFF344955),width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Color(0xFF344955),width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.red,width: 1.0),
    ),
    focusedBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.yellow[800],width: 1.0),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0)
);