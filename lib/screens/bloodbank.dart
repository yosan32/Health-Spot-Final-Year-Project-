import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:now_ui_flutter/screens/editBloodBank.dart';
//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';

import 'package:now_ui_flutter/widgets/card-category.dart';
import '../raisedButton/raised_button.dart';

import 'dart:convert';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View blood bank",
    "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPfvwbp4Zd9ai4CRWNh7LCmqcb0OuuiemfTw&usqp=CAU",
  }
};

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('bloodbanks');
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
  final String location;
  final String contact;

  Data({this.id, this.name, this.contact, this.location});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      name: json['name'],
      contact: json['contact'],
      location: json['location'],
    );
  }
}

class BloodBank extends StatefulWidget {
  BloodBank({Key key}) : super(key: key);

  @override
  _BloodBankState createState() => _BloodBankState();
}

class _BloodBankState extends State<BloodBank> {
  Future<List<Data>> futureData;
  Future<String> userType;
  String _role;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    userType = getUserInfo();
    getUserInfo().then((value) {
      _role = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Blood Bank",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(
          currentPage: "Blood Bank",
        ),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
//
//
//

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),

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
                                    context, '/addBloodBank');
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
                                  child: Text("Add Blood Bank",
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
                      title: "Blood Banks",
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
                                        leading: const Icon(Icons.bloodtype),
                                        title: Text(data[index].name),
                                        subtitle: Text('Location: ' +
                                            data[index].location +
                                            '\n' +
                                            'Contact: ' +
                                            data[index].contact +
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
//                                                data.removeAt(index);
                                                      await CallApi()
                                                          .deleteData(
                                                              'bloodbanks/' +
                                                                  data[index]
                                                                      .id,
                                                              tokenString);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Blood Bank removed'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/bloodbank');
                                                    } catch (e) {
                                                      print(e);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Cannot remove the blood bank'),
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
                                                          new EditBloodBank(
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
