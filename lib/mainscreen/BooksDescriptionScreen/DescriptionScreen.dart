import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miniproject/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DescriptionScreen extends StatefulWidget {
  final String imageUrl;
  final String bookName;
  final String description;
  final double price;
  final int noOfPages;
  final String publishDate;
  final String soldBy;
  final int serialId;
  final String bookPdf;
  final List<dynamic> boughtBy;
  final int categoryId;
  DescriptionScreen({
    this.imageUrl,
    this.description,
    this.bookName,
    this.price,
    this.soldBy,
    this.noOfPages,
    this.publishDate,
    this.serialId,
    this.bookPdf,
    this.boughtBy,
    this.categoryId,
  });
  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  Razorpay razorPay;
  int paymentStatus;
  bool payNowVisibile = true;
  bool isDownload = false;
  bool isLoading = false;

  List<dynamic> booksLike = [];
  @override
  void initState() {
    print(widget.soldBy);
    // TODO: implement initState
    super.initState();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    makeRequest();
  }

  makeRequest() async {
    var dio = Dio();
    dio.options.headers = {
      "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1"
    };
    Response response = await dio.get(
        'https://miniproject132.pythonanywhere.com/api/book?book_category=${widget.categoryId}');
    var res = response.data;
    for (int i = 0; i < res.length; i++) {
      setState(() {
        booksLike.add([
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
          res[i]["bought_by"]
        ]);
      });
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print('response : ${response.paymentId}');
    var dio = Dio();

    dio.options.headers = {
      "Authorization": "Token  613f83c277f3530efee673393e018c390af3afa1",
    };
    List<dynamic> buyers = widget.boughtBy;
    buyers.add(FirebaseAuth.instance.currentUser.email);
    isLoading = true;
    Response res = await dio.patch(
        'https://miniproject132.pythonanywhere.com/api/book/${widget.serialId}/',
        data: {"bought_by": buyers});
    print('Payment Success');
    setState(() {
      isLoading = false;
      payNowVisibile = false;
      isDownload = true;
      paymentStatus = 1;
    });
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print('Payment Failed');
    setState(() {
      paymentStatus = 0;
    });
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print('Payment Declined');
    setState(() {
      paymentStatus = 2;
    });
  }

  void openCheckout() async {
    var options = {
      "key": "rzp_test_YZPOHdmK6NxbwF",
      "amount": widget.price * 100,
      "name": "${FirebaseAuth.instance.currentUser.email}",
      "Description": "Payment for the ${widget.bookName}",
      "prefill": {
        "contact": "9012008071",
        "email": "hdsgks@gmail.com",
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kprimaryColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF344955),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) => (booksLike.length == 0)
            ? Center(
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 18.0,
                ),
              )
            : ModalProgressHUD(
                inAsyncCall: isLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          ClipPath(
                            clipper: MyClipping(),
                            child: Container(
                              width: width,
                              height: height / 4.5,
                              color: Color(0xFF344955),
                            ),
                          ),
                          Positioned(
                            top: height / 25,
                            left: width / 3.2,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(23.0),
                              child: Container(
                                height: height / 5,
                                width: width / 2.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(23.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Center(child: CircularProgressIndicator()),
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(23.0),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: widget.imageUrl,
                                          height: height / 5,
                                          width: width / 2.8,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height / 23),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                '${widget.bookName}',
                                style: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        width: width / 1.2,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\u{20B9} ${widget.price}',
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 20.0),
                            ),
                            Visibility(
                              visible: (widget.soldBy ==
                                          FirebaseAuth
                                              .instance.currentUser.email ||
                                      widget.boughtBy.contains(FirebaseAuth
                                          .instance.currentUser.email))
                                  ? true
                                  : isDownload,
                              child: RaisedButton(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Colors.blueAccent,
                                onPressed: () async {
                                  final status =
                                      await Permission.storage.request();
                                  if (status.isGranted) {
                                    final externalDir =
                                        await getExternalStorageDirectory();
                                    FlutterDownloader.enqueue(
                                        url: widget.bookPdf,
                                        savedDir: externalDir.path,
                                        fileName: '${widget.bookName}',
                                        showNotification: true,
                                        openFileFromNotification: true);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_circle_down),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text('Download'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 1.0,
                        width: width / 1.2,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                'Sold By : ${widget.soldBy}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                'No Of Pages : ${widget.noOfPages}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                'Serial ID : ${widget.serialId}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                'Publish Date : ${widget.publishDate.split('T')[0]}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        width: width / 1.1,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                (widget.description == null)
                                    ? 'No Description Provided By Seller'
                                    : '${widget.description}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 1.0,
                        width: width / 1.1,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 1.1,
                              child: Text(
                                'Books You May Like',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.yellow),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: width,
                          height: height / 4,
                          decoration: BoxDecoration(
                            color: Color(0xFF344955),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(23.0),
                              topRight: Radius.circular(23.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.015),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              itemCount: booksLike.length,
                              itemBuilder: (context, index) {
                                return (widget.serialId == booksLike[index][11])
                                    ? Container()
                                    : Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) {
                                                    return DescriptionScreen(
                                                      categoryId:
                                                          widget.categoryId,
                                                      boughtBy: booksLike[index]
                                                          [12],
                                                      soldBy: booksLike[index]
                                                          [5],
                                                      serialId: booksLike[index]
                                                          [11],
                                                      publishDate:
                                                          booksLike[index][8],
                                                      noOfPages:
                                                          booksLike[index][10],
                                                      description:
                                                          booksLike[index][6],
                                                      bookPdf: booksLike[index]
                                                          [7],
                                                      bookName: booksLike[index]
                                                          [0],
                                                      price: booksLike[index]
                                                          [1],
                                                      imageUrl: booksLike[index]
                                                          [3],
                                                    );
                                                  }),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: width / 2.8,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: height / 5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                23.0),
                                                        topRight:
                                                            Radius.circular(
                                                                23.0),
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                        Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      23.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      23.0),
                                                            ),
                                                            child: FadeInImage
                                                                .memoryNetwork(
                                                              placeholder:
                                                                  kTransparentImage,
                                                              image: booksLike[
                                                                  index][3],
                                                              height:
                                                                  height / 5,
                                                              width:
                                                                  width / 2.8,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 2.8,
                                                    child: Text(
                                                      booksLike[index][0],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          )
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Visibility(
        visible: (widget.boughtBy
                    .contains(FirebaseAuth.instance.currentUser.email) ||
                widget.soldBy == FirebaseAuth.instance.currentUser.email)
            ? false
            : payNowVisibile,
        child: Container(
          height: 65.0,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 30.0,
                  ),
                  Text(
                    '\u{20B9} ${widget.price}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  openCheckout();
                  String status = '';
                  if (paymentStatus == 1) {
                    status = 'Successful';
                  } else if (paymentStatus == 0) {
                    status = 'UnSuccessful';
                  } else if (paymentStatus == 2) {
                    status = 'Declined';
                  }
                  final snackBar =
                      SnackBar(content: Text('Your Payment was $status'));
                  Scaffold.of(context).showSnackBar(snackBar);
                },
                child: Row(
                  children: [
                    Text(
                      'Pay Now',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipping extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 9, size.height - 65, size.width / 6, size.height - 70);
    path.lineTo(size.width - 60, size.height - 70);
//    path.quadraticBezierTo(3/4*size.width, size.height,
//        size.width, size.height-30);
    path.quadraticBezierTo(
        size.width - 25, size.height - 75, size.width, size.height - 140);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
