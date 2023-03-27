import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/addAppointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../raisedButton/raised_button.dart';

//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';

import 'package:now_ui_flutter/widgets/card-category.dart';

import 'dart:convert';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View doctor",
    "image":
        "https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?w=300",
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
  final response = await CallApi().getData('users');
  var body = json.decode(response.body);

  List doctors = [];
  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];

    for (var i = 0; i < jsonResponse.length; i++) {
      if (body['payload']['data'][i]['role_id'] == 3) {
        doctors.add(body['payload']['data'][i]);
      }
    }
    return doctors.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;
  final String full_name;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  final String department;
  final String password;

  Data(
      {this.id,
      this.full_name,
      this.phone,
      this.email,
      this.department,
      this.first_name,
      this.last_name,
      this.password});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'].toString(),
        full_name: json['full_name'],
        phone: json['phone'],
        email: json['email'],
        department: json['department'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        password: json['password']);
  }
}

class Doctor extends StatefulWidget {
  Doctor({Key key}) : super(key: key);

  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
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
          title: "Doctors",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(
          currentPage: "Doctor",
        ),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                                    context, '/addDoctor');
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
                                  child: Text("Add Doctor",
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
                      title: "Doctors", img: articlesCards["Content"]["image"]),
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
                                        leading: const Icon(Icons.person),
                                        title: Text(data[index].full_name),
                                        subtitle: Text('Email: ' +
                                            data[index].email +
                                            '\n' +
                                            'Phone : ' +
                                            data[index].phone +
                                            '\n' +
                                            'Department: ' +
                                            data[index].department +
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
                                                              'users/' +
                                                                  data[index]
                                                                      .id,
                                                              tokenString);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Doctor removed'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                      Navigator.pushNamed(
                                                          context, '/doctor');
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Cannot remove the Doctor'),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(Icons.remove,
                                                      color: Colors.red),
                                                  label: Text("Delete"),
                                                ),
                                              ],
                                              if (_role == '2') ...[
                                                OutlinedButton.icon(
                                                  onPressed: () => {
                                                    Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new AddAppointment(
                                                                index:
                                                                    data[index]
                                                                        .id),
                                                      ),
                                                    )
                                                  },
                                                  icon: Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.blue),
                                                  label: Text("Book"),
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
