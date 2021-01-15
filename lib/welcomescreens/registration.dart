import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniproject/SharedPreferences/SharedPreferences.dart';
import 'package:miniproject/constants.dart';

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

  Future getImageFromGallery() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        extension = pickedFile.path
            .substring(pickedFile.path.length - 3, pickedFile.path.length);
        print(_image);
      } else {
        print("no File Selected");
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      useRootNavigator: true,
                      enableDrag: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: FlatButton(
                                      onPressed: () async {
                                        await getImageFromCamera();
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          Container(
                                            height: 65.0,
                                            width: 65.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                              color: Colors.grey[200],
                                            ),
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            'Camera',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 55.0,
                                    child: VerticalDivider(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: FlatButton(
                                      onPressed: () async {
                                        await getImageFromGallery();
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          Container(
                                            height: 65.0,
                                            width: 65.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                              color: Colors.grey[200],
                                            ),
                                            child: Icon(
                                              Icons.photo,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(50.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    child: (_image == null)
                        ? Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.black,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.file(_image,
                                width: 100, height: 100, fit: BoxFit.fitWidth),
                          ),
                  ),
                ),
              ),
              TextFieldAdder(
                hint: 'Enter Your Name',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  name = value;
                },
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    email = value;
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Enter Email',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextFormField(
                  maxLength: 10,
                  maxLengthEnforced: true,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    contactNumber = int.parse(value);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Enter Contact No',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  maxLength: 10,
                  maxLengthEnforced: true,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    rollNo = value;
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Enter Roll No',
                  ),
                ),
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
                    print(email);
                    if (email != null &&
                        contactNumber != null &&
                        rollNo != null &&
                        _image != null &&
                        password != null &&
                        password.length > 6) {
                      setState(() {
                        showWheel = true;
                      });
                      Dio dio = new Dio();
                      FormData formData = FormData.fromMap({
                        "user_mail": email.toLowerCase().trim(),
                        "user_name": name,
                        "contact_number": contactNumber,
                        "roll_no": rollNo,
                        "user_image": await MultipartFile.fromFile(
                          _image.path,
                          contentType: MediaType('image', extension),
                        ),
                      });
                      dio.options.headers["Authorization"] =
                          'Token 613f83c277f3530efee673393e018c390af3afa1';
                      try {
                        var response = await dio.post(
                          'https://miniproject132.pythonanywhere.com/api/user/',
                          data: formData,
                        );
                        if (response.statusCode == 201) {
                          try {
                            email = (email == null) ? ' ' : email;
                            password = (password == null) ? ' ' : password;

                            setState(() {
                              showWheel = true;
                            });
                            final user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: (email != null)
                                        ? email.toLowerCase().trim()
                                        : email,
                                    password: password);
                            await user.user.sendEmailVerification();
                            if (user != null) {
                              setState(() {
                                showWheel = false;
                              });
                              setUserEmail(email);
                              setUserPassword(password);
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
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          showWheel = false;
                        });
                        final snackbar = SnackBar(
                          content: Text(
                            'User Could Not be Created',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      }
                    } else {
                      if (_image == null) {
                        final snackbar = SnackBar(
                          content: Text(
                            'Please Select an Image',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      } else if (password == null) {
                        final snackbar = SnackBar(
                          content: Text(
                            'Please Enter a Password',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      } else if (password.length < 6) {
                        final snackbar = SnackBar(
                          content: Text(
                            'Password must be 6 Character Long',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      } else {
                        final snackbar = SnackBar(
                          content: Text(
                            'Please enter ${(name == null) ? 'Name' : (email == null) ? 'email' : (contactNumber == null) ? 'Contact No.' : (rollNo == null) ? 'Roll No' : ''}',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackbar);
                      }
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
