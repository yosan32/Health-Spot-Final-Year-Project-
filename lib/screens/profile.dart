import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
//widgets
import '../raisedButton/raised_button.dart';

import 'dart:convert';

import 'package:now_ui_flutter/screens/login.dart';

import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userData;
  var userId;
  int pageIndex = 0;
  bool isAuthenticated = false;

  PageController pageController;
  @override
  void initState() {
    getUserInfo();
    super.initState();
    pageController = PageController();
  }

  void getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      print(user);
      if (user != null) {
        userId = user['id'];
        isAuthenticated = true;
      } else {
        isAuthenticated = false;
      }
    });
  }

  Scaffold authScreen() {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Profile",
          transparent: true,
          bgColor: Colors.black,

        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Profile"),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/imgs/bg-profile.png"),
                              fit: BoxFit.cover,

                              alignment: Alignment.center
                          ),),
                      child: Column(
                        children: [
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            child:                 Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 32.0, right: 32.0, top: 42.0),
                                  child: Column(children: [
                                    SizedBox(
                                      height: 150,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                       color: Colors.amber,
                                        border: Border.all(width: 4,color: Colors.white)
                                      ),
                                      width: MediaQuery.of(context).size.width*0.5,
                                      child: Text("About me",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30.0,
                                          ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24.0, right: 24, top: 30, bottom: 24),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.info,
                                          onPressed: () {
                                            // Respond to button press
                                            Navigator.pushReplacementNamed(context, '/home');
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Text(
                                                  "First Name: " + userData['first_name'],
                                                  style: TextStyle(fontSize: 18.0))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.info,
                                          onPressed: () {
                                            // Respond to button press
                                            Navigator.pushReplacementNamed(context, '/home');
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Text(
                                                  "Last Name: " + userData['last_name'],
                                                  style: TextStyle(fontSize: 18.0))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.info,
                                          onPressed: () {
                                            // Respond to button press
                                            Navigator.pushReplacementNamed(context, '/home');
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Text("Username: " + userData['email'],
                                                  style: TextStyle(fontSize: 18.0))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.info,
                                          onPressed: () {
                                            // Respond to button press
                                            Navigator.pushReplacementNamed(context, '/home');
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Text(
                                                  "Phone Number: " + userData['phone'],
                                                  style: TextStyle(fontSize: 18.0))),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )),

                            /*child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Text(
                                        userData['first_name'] +
                                            ' ' +
                                            userData['last_name'] +
                                            ' ' +
                                            userData['id'].toString(),
                                        style: TextStyle(
                                            color: NowUIColors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(userData['email'],
                                        style: TextStyle(
                                            color: NowUIColors.white
                                                .withOpacity(0.85),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, left: 42, right: 32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("",
                                                style: TextStyle(
                                                    color: NowUIColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget build(BuildContext context) {
    print(isAuthenticated);
    return isAuthenticated ? authScreen() : Login();
  }
}
