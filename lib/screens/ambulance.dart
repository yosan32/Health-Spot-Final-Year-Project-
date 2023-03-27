import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:now_ui_flutter/screens/editAmbulance.dart';
//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:now_ui_flutter/widgets/card-category.dart';

import 'dart:convert';
import '../raisedButton/raised_button.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View ambulance",
    "image":
        "https://images.unsplash.com/photo-1576602975754-efdf313b9342?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBoYXJtYWN5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  }
};
// ignore: missing_return
Future<List<String>> getHospital(int id) async {
  final response = await CallApi().getData('hospitals');
  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    print(body);
    List jsonResponse = [];
    for (var i = 0; i < 0; i++) {
      if (body['payload']['data'][i]['id'] == id) {
        jsonResponse.add(body['payload']['data'][i]['name']);
        return jsonResponse;
      }
    }
  } else {
    throw Exception('ole');
  }
}

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('ambulances');
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
  final String vehicle_number;
  final String driver_number;
  final String hospital_id;

  Data({this.id, this.vehicle_number, this.driver_number, this.hospital_id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      vehicle_number: json['vehicle_number'].toString(),
      driver_number: json['driver_number'].toString(),
      hospital_id: json['hospital']['name'],
    );
  }
}

class Ambulance extends StatefulWidget {
  Ambulance({Key key}) : super(key: key);

  @override
  _AmbulanceState createState() => _AmbulanceState();
}

class _AmbulanceState extends State<Ambulance> {
  Future<List<Data>> futureData;
  Future<String> userType;
  String name;
  String _role;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();

    userType = getUserInfo();

    print(name);
    getUserInfo().then((value) {
      _role = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Ambulances",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(
          currentPage: "Ambulance",
        ),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: FutureBuilder<String>(
                      future: userType,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          if (snapshot.data == "1") {
                            return RaisedButton(
                              textColor: NowUIColors.white,
                              color: NowUIColors.primary,
                              onPressed: () {
                                // Respond to button press
                                Navigator.pushReplacementNamed(
                                    context, '/addAmbulance');
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 32.0,
                                      right: 32.0,
                                      top: 12,
                                      bottom: 12),
                                  child: Text("Add Ambulance",
                                      style: TextStyle(fontSize: 14.0))),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return Text("");
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  CardCategory(
                      title: "Ambulances",
                      img: articlesCards["Content"]["image"]),
                  Center(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data> data = snapshot.data;
                          return Container(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(
                                            FontAwesomeIcons.ambulance),
                                        title: Text(data[index].hospital_id),
                                        subtitle: Text('Driver Number: ' +
                                            data[index].driver_number +
                                            '\n'
                                                'Vehicle Number: ' +
                                            data[index].vehicle_number +
                                            '\n'),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (_role == '1') ...[
                                                OutlinedButton.icon(
                                                  onPressed: () async {
                                                    // Respond to button press
                                                    try {
                                                      SharedPreferences
                                                          localStorage =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      var tokenString =
                                                          localStorage
                                                              .getString(
                                                                  'token');

                                                      await CallApi()
                                                          .deleteData(
                                                              'ambulances/' +
                                                                  data[index]
                                                                      .id,
                                                              tokenString);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Ambulance removed'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/ambulance');
                                                    } catch (e) {
                                                      print(e);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Cannot remove the Ambulance'),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(Icons.remove,
                                                      color: Colors.red),
                                                  label: Text("Delete"),
                                                ),
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    // Respond to button press
                                                    Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new EditAmbulance(
                                                              list: data,
                                                              index: index),
                                                    ));
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.yellow,
                                                  ),
                                                  label: Text("Edit"),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        isThreeLine: true,
                                      ),
                                    );
                                  }));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
