import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:miniproject/components/paddingbutton.dart';
import 'package:miniproject/components/textfieldadder.dart';
import 'package:miniproject/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  bool showWheel = false;
  var dio = Dio();
  List<List<dynamic>> categoryList = [];
  Map<String, dynamic> categoryMap = {};
  int selectedCategory = 1;

  Future getImageFromGallery() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        extension = pickedFile.path
            .substring(pickedFile.path.length - 3, pickedFile.path.length);
      } else {
        print("no File Selected");
      }
    });
  }

  makeRequest() async {
    Response response = await dio.get(
      'http://miniproject132.pythonanywhere.com/api/category/',
      options: Options(
        headers: {
          'Authorization': 'Token  613f83c277f3530efee673393e018c390af3afa1'
        },
      ),
    );
    if (response.statusCode == 200) {
      var res = response.data;
      setState(() {
        for (int i = 0; i < res.length; i++) {
          categoryList.add([
            res[i]["id"],
            '${res[i]["category_text"]} (${res[i]["branch_text"]["branch_text"]})'
          ]);
          categoryMap[
                  "${res[i]["category_text"]} (${res[i]["branch_text"]["branch_text"]})"] =
              res[i]["id"];
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeRequest();
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
      body: (categoryList.length == 0)
          ? SpinKitDualRing(
              color: Colors.white,
              size: 22.0,
            )
          : ModalProgressHUD(
              inAsyncCall: showWheel,
              progressIndicator: CircularProgressIndicator(),
              child: Builder(
                builder: (context) => SingleChildScrollView(
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
                          textInputType: TextInputType.number,
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
                        decoration: BoxDecoration(
                          color: Color(0xFF344955),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: FittedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 10.0),
                                child: Text(
                                  'Category : ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: DropdownButton(
                                  value: categoryList[selectedCategory - 1][1],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = categoryMap[value];
                                    });
                                  },
                                  items: List.generate(
                                    categoryList.length,
                                    (index) => DropdownMenuItem(
                                      value: categoryList[index][1],
                                      child: Text(
                                        '${categoryList[index][1]}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          bottom: height * 0.01,
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF344955),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                        onTap: () async {
                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowCompression: true,
                                            allowedExtensions: ['pdf'],
                                          );
                                          if (result != null) {
                                            setState(() {
                                              bookPdf = File(
                                                  result.files.single.path);
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 70.0,
                                          width: 70.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
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
                                      (bookPdf == null)
                                          ? 'Select a File'
                                          : 'Selected',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: PaddingButtons(
                          text: 'Upload Book',
                          onpressed: () async {
                            print(bookSerialId);
                            print(noOfPages);
                            print(publication);
                            print(bookName);
                            print(bookPdf);
                            print(_image);

                            if (bookSerialId != null &&
                                bookName != null &&
                                _image != null &&
                                bookPdf != null &&
                                author != null &&
                                publication != null &&
                                price != null &&
                                noOfPages != null) {
                              setState(() {
                                showWheel = true;
                              });
                              print(FirebaseAuth.instance.currentUser.email);
                              Dio dio = new Dio();
                              FormData formData = FormData.fromMap({
                                "book_serial_id": bookSerialId,
                                "sold_by":
                                    FirebaseAuth.instance.currentUser.email,
                                "book_category": selectedCategory,
                                "book_name": bookName,
                                "book_image": await MultipartFile.fromFile(
                                  _image.path,
                                  contentType: MediaType('image', extension),
                                ),
                                "book_pdf": await MultipartFile.fromFile(
                                    bookPdf.path,
                                    contentType: MediaType('file', 'pdf')),
                                "author": author,
                                "publication": publication,
                                "price": price,
                                "no_of_pages": noOfPages
                              });
                              dio.options.headers["Authorization"] =
                                  'Token 613f83c277f3530efee673393e018c390af3afa1';
                              try {
                                var response = await dio.post(
                                  'https://miniproject132.pythonanywhere.com/api/book/',
                                  data: formData,
                                );
                                if (response.statusCode == 201) {
                                  setState(() {
                                    showWheel = false;
                                  });
                                  final snackbar = SnackBar(
                                    content: Text(
                                      'Book Uploaded Successfully',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackbar);
                                }
                              } catch (e) {
                                print(e.message);
                                setState(() {
                                  showWheel = false;
                                });
                                final snackbar = SnackBar(
                                  content: Text(
                                    'error book Could Not be Uploaded',
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
                              } else if (bookPdf == null) {
                                final snackbar = SnackBar(
                                  content: Text(
                                    'Please Upload E Book',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                              } else {
                                final snackbar = SnackBar(
                                  content: Text(
                                    'Please enter ${(author == null) ? 'author\'s details' : (bookSerialId == null) ? 'Book\'s Serial Id' : (bookName == null) ? 'Title of Book' : (publication == null) ? 'Publication Details' : (price == null) ? 'Price Of Book' : (noOfPages == null) ? 'No of Pages' : ' '}',
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
