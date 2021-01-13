import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/constants.dart';
import 'package:miniproject/mainscreen/primaryScreen.dart';
import 'package:miniproject/welcomescreens/welcomescreen.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;
bool isUser = false;

Future getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      print(user);
      isUser = true;
    } else {
      isUser = false;
    }
    print(isUser);
  } catch (e) {
    print(e);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getCurrentUser();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        canvasColor: kprimaryColor,
        accentColor: kprimaryColor,
      ),
      home: (isUser == true) ? FrontPage() : WelcomeScreen(),
    ),
  );
}
