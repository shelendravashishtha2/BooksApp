import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/constants.dart';

final _auth = FirebaseAuth.instance;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kprimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: FogetPasswordBody(),
      ),
    );
  }
}

class FogetPasswordBody extends StatefulWidget {
  @override
  _FogetPasswordBodyState createState() => _FogetPasswordBodyState();
}

class _FogetPasswordBodyState extends State<FogetPasswordBody> {
  String email;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Text(
            'Forget Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontFamily: 'yellowtailregular',
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFieldAdder(
          textInputType: TextInputType.emailAddress,
          obscure: false,
          hint: 'Enter Your Email Id',
          onchanged: (value) {
            email = value;
          },
        ),
      ),
      PaddingButtons(
        text: 'Send Mail',
        onpressed: () async {
          try {
            email = (email == null) ? ' ' : email;
            await _auth.sendPasswordResetEmail(
                email: email.toLowerCase().trim());
            final snackbar = SnackBar(
              content: Text('An Email Is sent to you'),
            );
            Scaffold.of(context).showSnackBar(snackbar);
          } on FirebaseAuthException catch (e) {
            final snackbar = SnackBar(content: Text(e.message));
            Scaffold.of(context).showSnackBar(snackbar);
          }
        },
      ),
    ]);
  }
}
