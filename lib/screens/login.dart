import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api/api.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/profile.dart';
import 'package:now_ui_flutter/screens/register.dart';
//widgets
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../raisedButton/raised_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
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
                                        child: Text("Login",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                          placeholder: "Email",
                                          onChanged: (value) {},
                                          controller: emailController,
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
                                          controller: passwordController,
                                          pass: true,
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
                                                Text("Don't have an account ?"),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()),
                                              );
                                            },
                                          )),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        if (_isLoading) {
                                          return CircularProgressIndicator();
                                        } else {
                                          loginForm();
                                        }
                                      },

                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(32.0),
                                      // ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 32.0,
                                            right: 32.0,
                                            top: 12,
                                            bottom: 12),
                                        child: Text("Login",
                                            style: TextStyle(fontSize: 14.0)),
                                      ),
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

  void loginForm() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'password': passwordController.text,
      'email': emailController.text,
    };

    var res = await CallApi().postDataWithoutToken(data, 'login');
    var body = json.decode(res.body);

    if (body['status'] == 'success') {
      print(body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['payload']['data']['token']);
      localStorage.setString(
          'user', json.encode(body['payload']['data']['user']));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Logged in'),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Profile()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Credentials'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
