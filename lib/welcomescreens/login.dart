import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/mainscreen/primaryScreen.dart';
import 'package:miniproject/welcomescreens/forget%20password.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


final _auth= FirebaseAuth.instance;


class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {

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
                child: Text(
                  'Log In',
                  style:TextStyle(
                    color:Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'yellowtailregular',
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: TextButton(
                  onPressed: ()async{
                    Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPassword();}));
                  },
                  child: Hero(
                    tag: 'logo',
                    child: Text(
                        'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PaddingButtons(
              text: 'Log In',
              onpressed: ()async{
                setState(() {
                  showWheel=true;
                });
                try{
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email.toLowerCase().trim(), password: password);
                  if (user!=null && _auth.currentUser.emailVerified) {
                    setState(() {
                      showWheel=false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FrontPage();
                    }));
                  }
                  else{
                    setState(() {
                      showWheel=true;
                    });
                    final snackbar = SnackBar(content: Text('email is not verified',style: TextStyle(color: Colors.black),),);
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                }
                catch(e){
                  setState(() {
                    showWheel = false;
                  });
                  final snackbar = SnackBar(content: Text(e.message));
                  Scaffold.of(context).showSnackBar(snackbar);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
