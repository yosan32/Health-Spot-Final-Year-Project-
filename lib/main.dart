import 'package:flutter/material.dart';
import 'package:now_ui_flutter/screens/addAmbulance.dart';
import 'package:now_ui_flutter/screens/addAppointment.dart';
import 'package:now_ui_flutter/screens/addBloodBank.dart';
import 'package:now_ui_flutter/screens/addDoctor.dart';
import 'package:now_ui_flutter/screens/addHospital.dart';
import 'package:now_ui_flutter/screens/addPharmacy.dart';
import 'package:now_ui_flutter/screens/addReminder.dart';
import 'package:now_ui_flutter/screens/ambulance.dart';
import 'package:now_ui_flutter/screens/appointment.dart';
import 'package:now_ui_flutter/screens/bloodbank.dart';
import 'package:now_ui_flutter/screens/chat.dart';
import 'package:now_ui_flutter/screens/doctor.dart';
import 'package:now_ui_flutter/screens/hospital.dart' show Hospital;
import 'package:now_ui_flutter/screens/login.dart';
import 'package:now_ui_flutter/screens/medicine.dart';
import 'package:now_ui_flutter/screens/pharmacy.dart';
// screens
import 'package:now_ui_flutter/screens/profile.dart';
import 'package:now_ui_flutter/screens/register.dart';
import 'package:now_ui_flutter/screens/reminder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Health System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: '/login',
        routes: <String, WidgetBuilder>{
          "/profile": (BuildContext context) => new Profile(),
          "/account": (BuildContext context) => new Register(),
          "/login": (BuildContext context) => new Login(),
          "/reminder": (BuildContext context) => new Reminder(),
          "/pharmacy": (BuildContext context) => new Pharmacy(),
          "/appointment": (BuildContext context) => new Appointment(),
          "/bloodbank": (BuildContext context) => new BloodBank(),
          "/ambulance": (BuildContext context) => new Ambulance(),
          "/hospital": (BuildContext context) => new Hospital(),
          "/addBloodBank": (BuildContext context) => new AddBloodBank(),
          "/addHospital": (BuildContext context) => new AddHospital(),
          "/addPharmacy": (BuildContext context) => new AddPharmacy(),
          "/addReminder": (BuildContext context) => new AddReminder(),
          "/addAmbulance": (BuildContext context) => new AddAmbulance(),
          "/addAppointment": (BuildContext context) => new AddAppointment(),
          "/medicine": (BuildContext context) => new Medicine(),
          "/doctor": (BuildContext context) => new Doctor(),
          "/addDoctor": (BuildContext context) => new AddDoctor(),
          "/chat": (BuildContext context) => new ChatPage(
                username: '',
              ),
        });
  }
}
