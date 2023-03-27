import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import '../raisedButton/raised_button.dart';

import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController date = TextEditingController();

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
        drawer: NowDrawer(currentPage: "Reminder"),
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
                                        child: Text("Add Reminder",
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
                                          placeholder: "Title",
                                          onChanged: (value) {},
                                          controller: title,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Note",
                                          onChanged: (value) {},
                                          controller: description,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Center(
                                            child: TextField(
                                          readOnly: true,
                                          controller: date,
                                          decoration:
                                              InputDecoration(hintText: 'Date'),
                                          onTap: () async {
                                            var dates = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            date.text = dates
                                                .toString()
                                                .substring(0, 10);
                                          },
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: _selectTime,
                                                child: Text('Time'),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Selected time: ${_time.format(context)}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        reminderForm();
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
                                                context, '/reminder');
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

  void reminderForm() async {
    setState(() {});
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm();
      return format.format(dt);
    }

    String tame = formatTimeOfDay(_time);

    var data = {
      'title': title.text,
      'description': description.text,
      'user_id': user['id'],
      'date': date.text,
      'time': tame
    };

    var tokenString = localStorage.getString('token');
    var res = await CallApi().postDataWithToken(data, 'reminders', tokenString);

    var body = json.decode(res.body);

    if (body['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Added'),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacementNamed(context, '/reminder');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Note cannot be added'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {});
  }
}
