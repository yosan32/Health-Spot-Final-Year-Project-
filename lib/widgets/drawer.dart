import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'package:now_ui_flutter/widgets/drawer-tile.dart';
import 'package:now_ui_flutter/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//widgets

import 'dart:convert';

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

// ignore: must_be_immutable
class NowDrawer extends StatefulWidget {
  String currentPage;

  NowDrawer({this.currentPage});

  @override
  _NowDrawerState createState() => _NowDrawerState();
}

class _NowDrawerState extends State<NowDrawer> {
  final String page;

  _NowDrawerState({this.page});

  Future<String> _role;

  @override
  void initState() {
    super.initState();

    _role = getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color:Colors.amber,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.menu,
                              color: NowUIColors.white.withOpacity(0.82),
                              size: 24.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Health Spot",
                        style: TextStyle(
                            color: NowUIColors.white.withOpacity(0.82),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        FutureBuilder<String>(
          future: _role,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data == "1") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [


                        DrawerTile(
                            icon: FontAwesomeIcons.home,
                            onTap: () {
                              if (page != "Profile")
                                Navigator.pushReplacementNamed(
                                    context, '/profile');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Profile",
                            isSelected: page == "Profile" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.ambulance,
                            onTap: () {
                              if (page != "Ambulance")
                                Navigator.pushReplacementNamed(
                                    context, '/ambulance');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Ambulance",
                            isSelected: page == "Ambulance" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.ambulance,
                            onTap: () {
                              if (page != "Doctor")
                                Navigator.pushReplacementNamed(
                                    context, '/doctor');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Doctor",
                            isSelected: page == "Doctor" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.water,
                            onTap: () {
                              if (page != "Blood Bank")
                                Navigator.pushReplacementNamed(
                                    context, '/bloodbank');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Blood Bank",
                            isSelected: page == "Blood Bank" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.hospital,
                            onTap: () {
                              if (page != "Hospitals")
                                Navigator.pushReplacementNamed(
                                    context, '/hospital');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Hospitals",
                            isSelected: page == "Hospitals" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.firstAid,
                            onTap: () {
                              if (page != "Pharmacy")
                                Navigator.pushReplacementNamed(
                                    context, '/pharmacy');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Pharmacy",
                            isSelected: page == "Pharmacy" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.pills,
                            onTap: () {
                              if (page != "Medicine")
                                Navigator.pushReplacementNamed(
                                    context, '/medicine');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Medicine",
                            isSelected: page == "Medicine" ? true : false),
                      ]),
                );
              } else if (snapshot.data == "2") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [

                        DrawerTile(
                            icon: FontAwesomeIcons.home,
                            onTap: () {
                              if (page != "Profile")
                                Navigator.pushReplacementNamed(
                                    context, '/profile');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Profile",
                            isSelected: page == "Profile" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.ambulance,
                            onTap: () {
                              if (page != "Ambulance")
                                Navigator.pushReplacementNamed(
                                    context, '/ambulance');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Ambulance",
                            isSelected: page == "Ambulance" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.ambulance,
                            onTap: () {
                              if (page != "Doctor")
                                Navigator.pushReplacementNamed(
                                    context, '/doctor');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Doctor",
                            isSelected: page == "Doctor" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.water,
                            onTap: () {
                              if (page != "Blood Bank")
                                Navigator.pushReplacementNamed(
                                    context, '/bloodbank');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Blood Bank",
                            isSelected: page == "Blood Bank" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.hospital,
                            onTap: () {
                              if (page != "Hospitals")
                                Navigator.pushReplacementNamed(
                                    context, '/hospital');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Hospitals",
                            isSelected: page == "Hospitals" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.firstAid,
                            onTap: () {
                              if (page != "Pharmacy")
                                Navigator.pushReplacementNamed(
                                    context, '/pharmacy');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Pharmacy",
                            isSelected: page == "Pharmacy" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.pills,
                            onTap: () {
                              if (page != "Medicine")
                                Navigator.pushReplacementNamed(
                                    context, '/medicine');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Medicine",
                            isSelected: page == "Medicine" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.bell,
                            onTap: () {
                              if (page != "Reminder")
                                Navigator.pushReplacementNamed(
                                    context, '/reminder');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Reminder",
                            isSelected: page == "Reminder" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.clock,
                            onTap: () {
                              if (page != "Appointments")
                                Navigator.pushReplacementNamed(
                                    context, '/appointment');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Appointments",
                            isSelected: page == "Appointments" ? true : false),
                      ]),
                );
              } else if (snapshot.data == "3") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [
                        DrawerTile(
                            icon: FontAwesomeIcons.home,
                            onTap: () {
                              if (page != "Profile")
                                Navigator.pushReplacementNamed(
                                    context, '/profile');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Profile",
                            isSelected: page == "Profile" ? true : false),
                        DrawerTile(
                            icon: FontAwesomeIcons.clock,
                            onTap: () {
                              if (page != "Appointments")
                                Navigator.pushReplacementNamed(
                                    context, '/appointment');
                            },
                            iconColor: NowUIColors.primary,
                            title: "Appointments",
                            isSelected: page == "Appointments" ? true : false),
                      ]),
                );
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return Text("");
          },
        ),
        Container(
            padding: EdgeInsets.only(left: 8, right: 16),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                    height: 4,
                    thickness: 0,
                    color: NowUIColors.white.withOpacity(0.8)),
                DrawerTile(
                    icon: FontAwesomeIcons.signOutAlt,
                    onTap: () async {
                      await CallApi().postDataWithoutToken({}, 'logout');
                      Navigator.pushNamed(context, '/login');
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      localStorage.remove('token');
                      localStorage.remove('user');
                    },
                    iconColor: NowUIColors.muted,
                    title: "Logout",
                    isSelected: page == "Getting started" ? true : false),
              ],
            )),
      ]),
    ));
  }
}
