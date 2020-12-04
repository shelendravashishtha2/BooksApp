import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/constants.dart';
import 'package:miniproject/welcomescreens/welcomescreen.dart';
import 'chatsystem/chatscreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: kprimaryColor,
      ),
      home:WelcomeScreen(),
    ),
  );
}
