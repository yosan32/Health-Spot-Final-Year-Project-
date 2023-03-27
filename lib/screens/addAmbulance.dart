import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../raisedButton/raised_button.dart';

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('hospitals');
  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;
  final String name;

  Data({this.id, this.name});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class AddAmbulance extends StatefulWidget {
  AddAmbulance({Key key}) : super(key: key);

  @override
  _AddAmbulanceState createState() => _AddAmbulanceState();
}

class _AddAmbulanceState extends State<AddAmbulance> {
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Data _currentUser;

  TextEditingController vehicle_number = TextEditingController();
  TextEditingController driver_number = TextEditingController();
  TextEditingController hospital_id = TextEditingController();

  final double height = window.physicalSize.height;

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
                                        child: Text("Add Ambulance",
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
                                          placeholder: "Vehicle Number",
                                          onChanged: (value) {},
                                          controller: vehicle_number,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Driver Number",
                                          onChanged: (value) {},
                                          controller: driver_number,
                                        ),
                                      ),
                                      FutureBuilder<List<Data>>(
                                          future: futureData,

                                          // ignore: missing_return
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Center(
                                                  child: DropdownButton<Data>(
                                                value: null,
                                                isDense: true,
                                                items: snapshot.data
                                                    .map((user) =>
                                                        DropdownMenuItem<Data>(
                                                          child:
                                                              Text(user.name),
                                                          value: user,
                                                        ))
                                                    .toList(),

                                                onChanged: (Data data) {
                                                  setState(() {
                                                    _currentUser = data;
                                                  });
                                                },
                                                isExpanded: false,
                                                //value: _currentUser,
                                                hint: Text(_currentUser == null
                                                    ? "Select Hospital"
                                                    : _currentUser.name),
                                              ));
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        ambulanceForm();
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Add",
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

  void ambulanceForm() async {
    setState(() {});
    var data = {
      'vehichle_number': vehicle_number.text,
      'driver_number': driver_number.text,
      'hospital_id': _currentUser.id,
    };
    print(data);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenString = localStorage.getString('token');
    var res =
        await CallApi().postDataWithToken(data, 'ambulances', tokenString);
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Added'),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacementNamed(context, '/ambulance');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ambulance cannot be added'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {});
  }
}
