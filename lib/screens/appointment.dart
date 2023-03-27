import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';

import 'package:now_ui_flutter/widgets/card-category.dart';

import 'dart:convert';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View appointment",
    "image":
        "https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?w=300",
  }
};

Future<List<Data>> fetchData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);
  final response = await CallApi().getData('appointments');
  var body = json.decode(response.body);
  List today = [];
  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];
    for (var i = 0; i < jsonResponse.length; i++) {
      if (user['id'] == body['payload']['data'][i]['doctor_id'] ||
          user['id'] == body['payload']['data'][i]['patient_id']) {
        // if (dt.day == DateTime.now().day) {
        today.add(body['payload']['data'][i]);
        // }
      }
    }
    return today.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;
  final String patient;
  final String doctor;

  final String trainer_id;
  final String customer_id;
  final String appointment_date;
  final String appointment_time;

  Data(
      {this.id,
      this.trainer_id,
      this.customer_id,
      this.appointment_date,
      this.appointment_time,
      this.doctor,
      this.patient});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      patient: json['patient']['id'].toString(),
      doctor: json['doctor']['id'].toString(),
      trainer_id: json['doctor']['full_name'],
      customer_id: json['patient']['full_name'],
      appointment_date: json['appointment_date'],
      appointment_time: json['appointment_time'],
    );
  }
}

Future<String> getUserInfo() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);

  int userType = user['role_id'];

  return userType.toString();
}

class Appointment extends StatefulWidget {
  Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  Future<List<Data>> futureData;
  Future<String> userType;
  String _role;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    userType = getUserInfo();
    getUserInfo().then((value) => _role = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Appointments",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Appointment"),
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

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),

                  CardCategory(
                      title: "Appointments",
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
                                        leading:
                                            const Icon(Icons.calendar_today),
                                        title: Text(data[index].customer_id),
                                        subtitle: Column(
                                          children: <Widget>[
                                            SizedBox(height: 8.0),
                                            Text("Doctor: " +
                                                data[index].trainer_id +
                                                '\n'),
                                            Text('Date: ' +
                                                data[index].appointment_date +
                                                '\n'),
                                            Text('Time: ' +
                                                data[index].appointment_time +
                                                '\n'),
                                          ],
                                        ),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if ((data[index]
                                                      .appointment_date) ==
                                                  DateTime.now()
                                                      .toString()
                                                      .substring(0, 10)) ...[
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    if (_role == '2') {
                                                      Navigator.of(context).push(
                                                          new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new ChatPage(
                                                                username:
                                                                    data[index]
                                                                        .patient,
                                                                receiver:
                                                                    data[index]
                                                                        .doctor,
                                                                receiverName: data[
                                                                        index]
                                                                    .trainer_id),
                                                      ));
                                                    } else if (_role == '3') {
                                                      Navigator.of(context).push(
                                                          new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new ChatPage(
                                                                username:
                                                                    data[index]
                                                                        .doctor,
                                                                receiver: data[
                                                                        index]
                                                                    .patient,
                                                                receiverName: data[
                                                                        index]
                                                                    .customer_id),
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(Icons.chat,

                                                      color: Colors.purple),
                                                  label: Text("Chat"),
                                                )
                                              ],
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
                                                            .getString('token');

//                                                      data.removeAt(index);
                                                    await CallApi().deleteData(
                                                        'appointments/' +
                                                            data[index].id,
                                                        tokenString);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Appointment removed'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                    Navigator.pushNamed(context,
                                                        '/appointment');
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Cannot remove the Appointment'),
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
                ],
              ),
            )));
  }
}
