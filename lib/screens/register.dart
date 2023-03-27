import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/screens/login.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'dart:convert';
import '../raisedButton/raised_button.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Register",
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
                                        child: Text("Register",
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
                                          pass: true,
                                          onChanged: (value) {},
                                          controller: password,
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: InkWell(
                                            child:
                                                Text("Already have an account"),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()),
                                              );
                                            },
                                          )),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        registerForm();
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
                                          child: Text("Register",
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

  void registerForm() async {
    setState(() {});
    var data = {
      'first_name': firstname.text,
      'last_name': lastname.text,
      'phone': phone.text,
      'email': username.text,
      'password': password.text,
      'password_confirmation': password.text,
      "department": "not given",
      'role_id': 2,
    };

    var res = await CallApi().postDataWithoutToken(data, 'register');
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 'success') {
//      print(body);
//      SharedPreferences localStorage = await SharedPreferences.getInstance();
//      localStorage.setString('token', body['token']);
//      localStorage.setString('user', json.encode(body['user']));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Registered'),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration Cannot be Completed'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {});
  }
}
