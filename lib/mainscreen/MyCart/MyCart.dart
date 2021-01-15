import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miniproject/constants.dart';
import 'package:dio/dio.dart';
import 'package:miniproject/mainscreen/BooksDescriptionScreen/DescriptionScreen.dart';
import 'package:transparent_image/transparent_image.dart';

class MyCart extends StatefulWidget {
  final String subjectName;
  final int categoryId;
  MyCart({this.subjectName, this.categoryId});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<dynamic> categoryBooks = [];
  int loadValue = 0;
  makeRequest() async {
    var dio = Dio();
    dio.options.headers = {
      "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1"
    };
    Response response = await dio.get(
        'https://miniproject132.pythonanywhere.com/api/book?bought_by=${FirebaseAuth.instance.currentUser.email}');
    var res = response.data;
    setState(() {
      loadValue = 1;
    });
    for (int i = 0; i < res.length; i++) {
      setState(() {
        categoryBooks.add([
          res[i]["book_name"],
          res[i]["price"],
          res[i]["bought_by"].length,
          res[i]["book_image"],
          res[i]["author"],
          res[i]["sold_by"],
          res[i]["book_description"],
          res[i]["book_pdf"],
          res[i]["publish_date"],
          res[i]["publication"],
          res[i]["no_of_pages"],
          res[i]["book_serial_id"],
          res[i]["bought_by"],
          res[i]["book_category"],
        ]);
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
        backgroundColor: kprimaryColor,
        elevation: 1.0,
        centerTitle: true,
        title: Text('My Cart'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: (loadValue == 0)
          ? SpinKitFadingCircle(
              size: 30.0,
              color: Colors.white,
            )
          : (categoryBooks.length == 0)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/noRecordFound.png',
                        width: width / 2,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'No Record Found',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: categoryBooks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DescriptionScreen(
                              imageUrl: categoryBooks[index][3],
                              price: categoryBooks[index][1],
                              bookName: categoryBooks[index][0],
                              bookPdf: categoryBooks[index][7],
                              description: categoryBooks[index][6],
                              noOfPages: categoryBooks[index][10],
                              publishDate: categoryBooks[index][8],
                              serialId: categoryBooks[index][11],
                              soldBy: categoryBooks[index][5],
                              categoryId: categoryBooks[index][13],
                              boughtBy: categoryBooks[index][12],
                            );
                          }));
                        },
                        child: Material(
                          elevation: 1.0,
                          borderRadius: BorderRadius.circular(23.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF344955),
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: height / 7,
                                    width: width / 3.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(23.0),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                            child: CircularProgressIndicator()),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(23.0),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: categoryBooks[index][3],
                                              height: height / 7,
                                              width: width / 3.4,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width - width / 2.3,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              categoryBooks[index][0],
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      SizedBox(
                                        width: width - width / 2.3,
                                        child: Text(
                                          '\u{20B9} ${categoryBooks[index][1]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellowAccent,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      SizedBox(
                                        width: width - width / 2.3,
                                        child: Text(
                                          'Buys : ${categoryBooks[index][2]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellowAccent),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      SizedBox(
                                        width: width - width / 2.3,
                                        child: Text(
                                          'Author : ${categoryBooks[index][4]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellowAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
