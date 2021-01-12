import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BookRegistration extends StatefulWidget {
  @override
  _BookRegistrationState createState() => _BookRegistrationState();
}

class _BookRegistrationState extends State<BookRegistration> {
  File _image;
  final imagePicker = ImagePicker();
  String extension;
  String bookSerialId;
  String bookName;
  String author;
  String publication;
  double price;
  int noOfPages;
  File bookPdf;
  Future getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        bookPdf = File(result.files.single.path);
      });
    } else {
      // User canceled the picker
    }
  }

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kprimaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 1,
        backgroundColor: Color(0xFF344955),
        centerTitle: true,
        title: Text(
          'Register Book',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                ClipPath(
                  clipper: Clipper(),
                  child: Container(
                    width: width,
                    height: height / 5,
                    color: Color(0xFF344955),
                  ),
                ),
                Positioned(
                  top: height / 15,
                  left: width / 3.2,
                  child: GestureDetector(
                    onTap: getImageFromGallery,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      height: height / 5,
                      width: width / 2.8,
                      child: (_image == null)
                          ? Icon(
                              Icons.add_photo_alternate,
                              color: Colors.black,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: Image.file(
                                _image,
                                height: height / 5,
                                width: width / 2.8,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 13),
              child: TextFieldAdder(
                hint: 'Enter Serial Id',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  bookSerialId = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.0001),
              child: TextFieldAdder(
                hint: 'Enter Book Title',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  bookName = value;
                },
              ),
            ),
            Container(
              color: Color(0xFF344955),
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.0001,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Category : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    DropdownButton(
                      onChanged: (value) {},
                      items: [
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                        DropdownMenuItem(
                          child: Text('Programming (Computer Science)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: height * 0.02, bottom: height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Upload a Book',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(50.0),
                        elevation: 8.0,
                        child: GestureDetector(
                          onTap: getFile,
                          child: Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Icon(
                              Icons.picture_as_pdf_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'dnchdb',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.0001),
              child: TextFieldAdder(
                hint: 'Enter Author Name',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  author = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.0001),
              child: TextFieldAdder(
                hint: 'Enter Publication Name',
                obscure: false,
                textInputType: TextInputType.emailAddress,
                onchanged: (value) {
                  publication = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.0001),
              child: TextFieldAdder(
                hint: 'Enter Price',
                obscure: false,
                textInputType: TextInputType.number,
                onchanged: (value) {
                  price = double.parse(value);
                  print(price);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.0001),
              child: TextFieldAdder(
                hint: 'Enter No Of Pages',
                obscure: false,
                textInputType: TextInputType.number,
                onchanged: (value) {
                  noOfPages = int.parse(value);
                  print(noOfPages);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
