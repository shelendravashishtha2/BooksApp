import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/mainscreen/primaryScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _auth = FirebaseAuth.instance;

class PageThree extends StatefulWidget{

  @override
  _PageThreeState createState() => _PageThreeState();

}

class _PageThreeState extends State<PageThree> {

  String email;
  String password;
  bool showWheel=false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showWheel,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Hero(
                  tag: 'logo',
                  child: Text(
                    'Register',
                    style:TextStyle(
                      color:Colors.white,
                      fontSize: 30.0,
                      fontFamily: 'yellowtailregular',
                    ),
                  ),
                ),
              ),
            ),
            TextFieldAdder(
              hint: 'Enter Your Email',
              obscure: false,
              textInputType: TextInputType.emailAddress,
              onchanged: (value){
                email = value;
              },
            ),
            TextFieldAdder(
              hint: 'Enter Your Password',
              onchanged:(value){
                password = value;
              },
              obscure: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: PaddingButtons(
                text: 'Register',
                onpressed: ()async{
                  try {
                    setState(() {
                      showWheel = true;
                    });
                    final user = await _auth.createUserWithEmailAndPassword(
                        email:(email!=null) ? email.toLowerCase().trim() : email , password: password);
                    await user.user.sendEmailVerification();
                    if (user != null) {
                      setState(() {
                        showWheel = false;
                      });
                      final snackbar = SnackBar(content: Text('email verification is sent to you',style: TextStyle(color: Colors.black),));
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  }
                  catch(e){
                    setState(() {
                      showWheel = false;
                    });
                    final snackbar = SnackBar(content: Text(e.message,style: TextStyle(color: Colors.black),));
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
