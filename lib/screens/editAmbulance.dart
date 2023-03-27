import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'dart:convert';
import '../raisedButton/raised_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class EditAmbulance extends StatefulWidget {
  List list;
  int index;
  EditAmbulance({this.index, this.list});
  @override
  _EditAmbulanceState createState() => _EditAmbulanceState();
}

class _EditAmbulanceState extends State<EditAmbulance> {
  TextEditingController vehicle_number;
  TextEditingController driver_number;
  TextEditingController hospital_id;

  final double height = window.physicalSize.height;
  @override
  void initState() {
    vehicle_number = new TextEditingController(
        text: widget.list[widget.index].vehicle_number);
    driver_number = new TextEditingController(
        text: widget.list[widget.index].driver_number);
    hospital_id =
        new TextEditingController(text: widget.list[widget.index].hospital_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Ambulance"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          color: NowUIColors.bgColorScreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, bottom: 8),
                                    child: Center(
                                        child: Text("Edit Ambulance",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Name",
                                          onChanged: (value) {},
                                          controller: vehicle_number,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Contact",
                                          onChanged: (value) {},
                                          controller: driver_number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () async {
                                        // Respond to button press
                                        var data = {
                                          'vehichle_number':
                                              vehicle_number.text,
                                          'driver_number': driver_number.text,
                                          'hospital_id': hospital_id.text,
                                        };

                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        var tokenString =
                                            localStorage.getString('token');
                                        String id =
                                            widget.list[widget.index].id;

                                        var res = await CallApi().editData(data,
                                            'ambulances/' + id, tokenString);
                                        var body = json.decode(res.body);
                                        if (body['status'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Successfully Editted'),
                                            backgroundColor: Colors.greenAccent,
                                          ));
                                          Navigator.pushReplacementNamed(
                                              context, '/ambulance');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Ambulance cannot be Edited'),
                                            backgroundColor: Colors.redAccent,
                                          ));
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Edit",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: InkWell(
                                          child: Text("Back"),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/ambulance');
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));
  }
}
