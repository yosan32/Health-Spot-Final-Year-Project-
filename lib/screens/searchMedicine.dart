import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';

import 'package:now_ui_flutter/widgets/card-category.dart';

import 'dart:convert';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View Medicines",
    "image":
        "https://images.unsplash.com/photo-1587854692152-cbe660dbde88?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bWVkaWNpbmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  }
};

Future<List<Data>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://api.fda.gov/drug/ndc.json?search=finished:true&limit=100'));
  var body = json.decode(response.body);
  if (response.statusCode == 200) {
    List jsonResponse = body['results'];
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Cannot Load Medicines');
  }
}

class Data {
  final String id;
  final String generic_name;
  final String brand_name;
  final String labeler_name;
  final String dosage_form;

  Data(
      {this.id,
      this.generic_name,
      this.brand_name,
      this.labeler_name,
      this.dosage_form});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      generic_name: json['generic_name'],
      brand_name: json['brand_name'],
      labeler_name: json['labeler_name'],
      dosage_form: json['dosage_form'],
    );
  }
}

// ignore: must_be_immutable
class SearchMedicine extends StatefulWidget {
  String list;
  String b;
  String c;
  String d;

  SearchMedicine({this.list, this.b, this.c, this.d});

  @override
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  String generic_name;

  String brand_name;
  String dosage_form;
  String labeler_name;
  @override
  void initState() {
    super.initState();
//    print(widget.list[0]);
    generic_name = widget.list;
    brand_name = widget.b;
    dosage_form = widget.c;

    labeler_name = widget.d;
//    brand_name=new TextEditingController(text:widget.list[0].brand_name);
//    dosage_form=new TextEditingController(text:widget.list[0].dosage_form);
//    labeler_name=new TextEditingController(text:widget.list[0].labeler_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Medicine",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Medicine"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                          child: InkWell(
                            child: Text("Back"),
                            onTap: () {
                              Navigator.pushNamed(context, '/medicine');
                            },
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  CardCategory(
                      title: "Searched Medicines",
                      img: articlesCards["Content"]["image"]),
                  Center(
                    child: Container(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.bloodtype),
                          title: Text(generic_name),
                          subtitle: Text('Brand Name: ' +
                              brand_name +
                              '\n' +
                              'Dosage Form ' +
                              dosage_form +
                              '\n' +
                              'Label Company: ' +
                              labeler_name +
                              '\n'),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
