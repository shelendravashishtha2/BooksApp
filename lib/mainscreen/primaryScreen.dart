import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/MyProfile/MyProfile.dart';
import 'package:miniproject/SharedPreferences/SharedPreferences.dart';
import 'package:miniproject/constants.dart';
import 'package:miniproject/mainscreen/MyBooks/MyBooks.dart';
import 'package:miniproject/mainscreen/MyCart/MyCart.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:miniproject/mainscreen/BooksList/BooksList.dart';
import 'package:miniproject/mainscreen/BooksRegistration/BooksRegistration.dart';
import 'package:miniproject/welcomescreens/welcomescreen.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

final _auth = FirebaseAuth.instance;

class _FrontPageState extends State<FrontPage> {
  List<dynamic> cseList = [];
  List<dynamic> eceList = [];
  List<dynamic> itList = [];
  List<dynamic> elecList = [];
  List<dynamic> mechanicalList = [];
  List<String> userDetails = [];
  Future<bool> exit() async {
    return await showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.blueGrey.withOpacity(0.5),
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              bottom: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you want to exit the app",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                  // maxLines: 3,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 1,
                                  child: Divider(
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FlatButton(
                                      color: Colors.grey[200],
                                      padding: const EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        top: 10.0,
                                        bottom: 8.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.blueAccent,
                                      child: Text(
                                        'Cancel',
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      // Navigator.of(context).pop(false),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    FlatButton(
                                      color: Colors.grey[200],
                                      padding: const EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        top: 10.0,
                                        bottom: 8.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.blueAccent,
                                      child: Text(
                                        'Ok',
                                      ),
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }) ??
        false;
  }

  makeUserRequest() async {
    Response response = await get(
      'http://miniproject132.pythonanywhere.com/api/user/${_auth.currentUser.email}/',
      headers: {
        'Authorization': 'Token  613f83c277f3530efee673393e018c390af3afa1',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var res = jsonDecode(response.body);
      setState(() {
        userDetails.add(res["user_name"]);
        userDetails.add(res["user_image"]);
      });
    }
  }

  makeRequest() async {
    Response response = await get(
      'http://miniproject132.pythonanywhere.com/api/category/',
      headers: {
        'Authorization': 'Token  613f83c277f3530efee673393e018c390af3afa1',
      },
    );
    print(await getUserEmail());
    print(await getUserPassword());
    if (response.statusCode == 200) {
      String data = response.body;
      List<dynamic> res = jsonDecode(data);
      for (int i = 0; i < res.length; i++) {
        setState(() {
          switch (res[i]["branch_text"]["branch_text"]) {
            case 'CSE':
              cseList.add([
                res[i]["category_text"],
                res[i]["category_image"],
                res[i]["id"]
              ]);
              break;
            case 'Information Technology':
              itList.add([
                res[i]["category_text"],
                res[i]["category_image"],
                res[i]["id"]
              ]);
              break;
            case 'ECE':
              eceList.add([
                res[i]["category_text"],
                res[i]["category_image"],
                res[i]["id"]
              ]);
              break;
            case 'MECHANICAL':
              mechanicalList.add([
                res[i]["category_text"],
                res[i]["category_image"],
                res[i]["id"]
              ]);
              break;
            case 'ELECTRICAL':
              elecList.add([
                res[i]["category_text"],
                res[i]["category_image"],
                res[i]["id"]
              ]);
              break;
          }
        });
      }
    }
  }

  getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    makeRequest();
    makeUserRequest();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return (elecList.length == 0 || userDetails.length == 0)
        ? Container(
            color: kprimaryColor,
            child: SpinKitCircle(
              color: Colors.white,
              size: 50.0,
            ),
          )
        : WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              exit();
            },
            child: Scaffold(
              drawer: DrawerBuilder(height, context),
              backgroundColor: kprimaryColor,
              body: Builder(
                builder: (context) => SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          ClipPath(
                            clipper: MyClipping(),
                            child: Container(
                              width: width,
                              height: height / 2.5,
                              color: Color(0xFF344955),
                            ),
                          ),
                          Positioned(
                            top: height * 0.055,
                            left: width * 0.05,
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(Icons.clear_all_outlined),
                              iconSize: 24.0,
                            ),
                          ),
                          Positioned(
                            top: height * 0.055,
                            right: width * 0.05,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                  userDetails[1],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: height * 0.15,
                            left: width * 0.06,
                            child: Text(
                              'Hello ${userDetails[0].split(" ")[0]} !',
                              style: TextStyle(
                                  color: Colors.white, fontSize: height * 0.03),
                            ),
                          ),
                          Positioned(
                            top: height * 0.19,
                            left: width * 0.1,
                            child: Text(
                              'welcome to your book store ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 15.0),
                            ),
                          ),
                          Positioned(
                            top: height / 3.5,
                            width: width / 1.2,
                            left: width * 0.07,
                            child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                filled: true,
                                suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.search,
                                    color: kprimaryColor,
                                  ),
                                ),
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFF344955), width: 1.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (cseList.length > 0)
                        SubjectList(
                          width: width,
                          height: height,
                          branchName: 'CSE (Computer Science and Engineering)',
                          subjectDetail: cseList,
                        ),
                      if (eceList.length > 0)
                        SubjectList(
                          width: width,
                          height: height,
                          branchName:
                              'ECE (Electronics and Communication Engineering)',
                          subjectDetail: eceList,
                        ),
                      if (itList.length > 0)
                        SubjectList(
                          width: width,
                          height: height,
                          branchName: 'IT (Information Technology)',
                          subjectDetail: itList,
                        ),
                      if (mechanicalList.length > 0)
                        SubjectList(
                          width: width,
                          height: height,
                          branchName: 'Mechanical Engineering',
                          subjectDetail: mechanicalList,
                        ),
                      if (elecList.length > 0)
                        SubjectList(
                          width: width,
                          height: height,
                          branchName: 'Electrical Engineering',
                          subjectDetail: elecList,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // ignore: non_constant_identifier_names
  Drawer DrawerBuilder(double height, BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.yellow.shade200,
                  child: CircleAvatar(
                    radius: 58.0,
                    backgroundColor: kprimaryColor,
                    child: Material(
                      elevation: 7.0,
                      borderRadius: BorderRadius.circular(54.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 54.0,
                        backgroundImage: NetworkImage(
                          userDetails[1],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${userDetails[0].split(" ")[0]} ',
                  style:
                      TextStyle(color: Colors.white, fontSize: height * 0.03),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 1.0,
                  child: Divider(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            tileColor: Color(0xFF344955),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyProfile(
                      userImage: userDetails[1],
                      userName: userDetails[00],
                    );
                  },
                ),
              );
            },
            leading: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
            ),
            title: Text(
              'My Profile',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Divider(
              color: Colors.grey[150],
            ),
          ),
          ListTile(
            tileColor: Color(0xFF344955),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BookRegistration();
                  },
                ),
              );
            },
            leading: Icon(
              Icons.book_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Book Registration',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Divider(
              color: Colors.grey[150],
            ),
          ),
          ListTile(
            tileColor: Color(0xFF344955),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyBooks();
                  },
                ),
              );
            },
            leading: Icon(
              CupertinoIcons.book_circle,
              color: Colors.white,
            ),
            title: Text(
              'My Uploads',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Divider(
              color: Colors.grey[150],
            ),
          ),
          ListTile(
            tileColor: Color(0xFF344955),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyCart();
                  },
                ),
              );
            },
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            title: Text(
              'My Cart',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Divider(
              color: Colors.grey[150],
            ),
          ),
          ListTile(
            tileColor: Color(0xFF344955),
            onTap: () {
              _auth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
            leading: Icon(
              Icons.clear,
              color: Colors.redAccent,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent, fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectList extends StatelessWidget {
  const SubjectList({
    Key key,
    @required this.width,
    @required this.height,
    this.branchName,
    this.subjectDetail,
  }) : super(key: key);

  final double width;
  final double height;
  final List<dynamic> subjectDetail;
  final String branchName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width - 30.0,
                child: Text(
                  '$branchName',
                  style: TextStyle(fontSize: 22.0),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
          child: Container(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1,
              ),
              itemCount: subjectDetail.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BooksList(
                            categoryId: subjectDetail[index][2],
                            subjectName: subjectDetail[index][0],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Color(0xFF344955),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: height / 6.5,
                          width: width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23.0),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: subjectDetail[index][1],
                                    height: height / 6.5,
                                    width: width / 2.5,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${subjectDetail[index][0]}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class MyClipping extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
