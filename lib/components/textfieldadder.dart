import 'package:flutter/material.dart';
import 'package:miniproject/constants.dart';

class TextFieldAdder extends StatelessWidget {
  final TextInputType textInputType;
  final Function onchanged;
  final String hint;
  final bool obscure;
  TextFieldAdder({
    this.textInputType,
    @required this.hint,
    this.obscure,
    @required this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        enableSuggestions: false,
        keyboardType: textInputType,
        cursorColor: Colors.white,
        obscureText: obscure,
        onChanged: onchanged,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: kInputDecoration.copyWith(labelText: hint),
      ),
    );
  }
}
