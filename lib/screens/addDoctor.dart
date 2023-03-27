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

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  List<String> _texts = [
    "Anesthetics",
    "Breast Screening",
    "ENT",
    "Gastroenterology",
    "Neurology",
    "Oncology",
    "Urology",
    "Renal_Unit"
  ];
  List<bool> _isChecked;

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final double height = window.physicalSize.height;
  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(_texts.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NowDrawer(currentPage: "Doctor"),
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Add Doctors",
          rightOptions: false,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg.jpg"),
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
                                        child: Text("Add Doctors",
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
                                          placeholder: "First Name",
                                          onChanged: (value) {},
                                          controller: firstname,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "Last Name",
                                          onChanged: (value) {},
                                          controller: lastname,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Phone Number",
                                          onChanged: (value) {},
                                          controller: phone,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Email",
                                          onChanged: (value) {},
                                          controller: username,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Password",
                                          onChanged: (value) {},
                                          pass: true,
                                          controller: password,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _texts.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          title: Text(_texts[index]),
                                          value: _isChecked[index],
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                _isChecked[index] = val;
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        addDoctorForm();
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
                                          child: Text("Add Doctor",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
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

  void addDoctorForm() async {
    setState(() {});
    String dd = '';
    for (var i = 0; i < 8; i++) {
      if (_isChecked[i] == true) {
        dd = dd + _texts[i] + ',';
      }
    }
    var data = {
      'first_name': firstname.text,
      'last_name': lastname.text,
      'phone': phone.text,
      'email': username.text,
      'password': password.text,
      'password_confirmation': password.text,
      'department': dd,
      'role_id': 3,
    };
    print(data);
    var res = await CallApi().postDataWithoutToken(data, 'register');
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 'success') {
//      print(body);
//      SharedPreferences localStorage = await SharedPreferences.getInstance();
//      localStorage.setString('token', body['token']);
//      localStorage.setString('user', json.encode(body['user']));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Added'),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacementNamed(context, '/doctor');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration Cannot be Completed'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {});
  }
}
