import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';

final _auth = FirebaseAuth.instance;

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  String email;
  String password;
  int contactNumber;
  String name;
  String rollNo;
  bool showWheel = false;
  String extension;
  File _image;
  final imagePicker = ImagePicker();
  String imageSelect = 'Select an Image';

  Future getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageSelect = 'Image Selected';
        extension = pickedFile.path
            .substring(pickedFile.path.length - 3, pickedFile.path.length);
        print(_image);
      } else {
        print("no File Selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showWheel,
      child: SingleChildScrollView(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'yellowtailregular',
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.white),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    imageSelect,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextFieldAdder(
                hint: 'Enter Your Name',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  name = value;
                },
              ),
              TextFieldAdder(
                hint: 'Enter Your Email',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  email = value;
                },
              ),
              TextFieldAdder(
                hint: 'Enter Your Contact No.',
                obscure: false,
                textInputType: TextInputType.number,
                onchanged: (value) {
                  contactNumber = int.parse(value);
                  print(contactNumber);
                },
              ),
              TextFieldAdder(
                hint: 'Enter Your Roll No.',
                obscure: false,
                textInputType: TextInputType.number,
                onchanged: (value) {
                  rollNo = value;
                },
              ),
              TextFieldAdder(
                hint: 'Enter Your Password',
                onchanged: (value) {
                  password = value;
                },
                obscure: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: PaddingButtons(
                  text: 'Register',
                  onpressed: () async {
                    setState(() {
                      showWheel = true;
                    });
                    Dio dio = new Dio();
                    FormData formData = FormData.fromMap({
                      "user_mail": email,
                      "user_name": name,
                      "contact_number": contactNumber,
                      "roll_no": rollNo,
                      "user_image": await MultipartFile.fromFile(
                        _image.path,
                        contentType: MediaType('image', extension),
                      ),
                    });
                    dio.options.headers["Authorization"] =
                        'Token 6e2b45c516600ae62575504eb5b5fbaa65c26c66';
                    var response = await dio.post(
                      'https://miniproject132.pythonanywhere.com/api/user/',
                      data: formData,
                    );
                    if (response.statusCode == 201) {
                      try {
                        email = (email == null) ? ' ' : email;
                        password = (password == null) ? ' ' : password;

                        setState(
                          () {
                            showWheel = true;
                          },
                        );
                        final user = await _auth.createUserWithEmailAndPassword(
                            email: (email != null)
                                ? email.toLowerCase().trim()
                                : email,
                            password: password);
                        await user.user.sendEmailVerification();
                        if (user != null) {
                          setState(() {
                            showWheel = false;
                          });
                          final snackbar = SnackBar(
                            content: Text(
                              'email verification is sent to you',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                      } catch (e) {
                        setState(() {
                          showWheel = false;
                        });
                        final snackbar = SnackBar(
                            content: Text(
                          e.message,
                          style: TextStyle(color: Colors.black),
                        ));
                        Scaffold.of(context).showSnackBar(snackbar);
                      }
                    } else {
                      print(response.statusMessage);
                      setState(() {
                        showWheel = false;
                      });
                      final snackbar = SnackBar(
                          content: Text(
                        'User Could Not be Created',
                        style: TextStyle(color: Colors.black),
                      ));
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
