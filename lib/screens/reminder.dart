import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/editReminder.dart';
import 'package:now_ui_flutter/widgets/card-category.dart';
//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../raisedButton/raised_button.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View reminder",
    "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPfvwbp4Zd9ai4CRWNh7LCmqcb0OuuiemfTw&usqp=CAU",
  }
};

Future<List<Data>> fetchData() async {
  final response = await CallApi().getData('reminders');
  var body = json.decode(response.body);
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userJson = localStorage.getString('user');
  var user = json.decode(userJson);
  print(body);

  List mine = [];
  if (response.statusCode == 200) {
    List jsonResponse = body['payload']['data'];
    for (var i = 0; i < jsonResponse.length; i++) {
      if (body['payload']['data'][i]['user_id'] == user['id']) {
        mine.add(body['payload']['data'][i]);
      }
    }

    return mine.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;
  final String title;
  final String description;
  final int user_id;
  final String date;
  final String time;

  Data(
      {this.id,
      this.title,
      this.description,
      this.user_id,
      this.date,
      this.time});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      user_id: json['user_id'],
      date: json['date'],
      time: json['time'],
    );
  }
}

class Reminder extends StatefulWidget {
  Reminder({Key key}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Reminders",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Reminder"),
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
                    child: RaisedButton(
                      textColor: NowUIColors.white,
                      color: NowUIColors.primary,
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/addReminder');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 32.0, right: 32.0, top: 12, bottom: 12),
                          child: Text("Add Reminder",
                              style: TextStyle(fontSize: 14.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),

                  CardCategory(
                      title: "Reminders",
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
                                            const Icon(Icons.local_hospital),
                                        title: Text(data[index].title),
                                        subtitle: Column(
                                          children: <Widget>[
                                            SizedBox(height: 8.0),
                                            Text(
                                                data[index].description + '\n'),
                                            Text('Date: ' +
                                                data[index].date +
                                                '\n'),
                                            Text('Time: ' +
                                                data[index].time +
                                                '\n'),
                                          ],
                                        ),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
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
                                                        'reminders/' +
                                                            data[index].id,
                                                        tokenString);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Reminder removed'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                    Navigator.pushNamed(
                                                        context, '/reminder');
                                                  } catch (e) {
                                                    print(e);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Cannot remove the Reminder'),
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
                                                        new EditReminder(
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
