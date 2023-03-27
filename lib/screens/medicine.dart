import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/screens/searchMedicine.dart';
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

class Medicine extends StatefulWidget {
  Medicine({Key key}) : super(key: key);

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  Future<List<Data>> futureData;
  TextEditingController search = TextEditingController();
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                        child: Input(
                          placeholder: "Search",
                          onChanged: (value) {},
                          controller: search,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                          child: InkWell(
                            child: Text("Search"),
                            onTap: () async {
                              final response = await http.get(Uri.parse(
                                  'https://api.fda.gov/drug/ndc.json?search=' +
                                      search.text));
                              var body = json.decode(response.body);
                              if (response.statusCode == 200) {
                                print(body);
//                                      List<Med> jsonResponse =  body['results'];
                                String a = body['results'][0]['generic_name'];
                                String b = body['results'][0]['brand_name'];
                                String c = body['results'][0]['dosage_form'];
                                String d = body['results'][0]['labeler_name'];

//                                      Navigator.push(
//                                        context,
//                                        new MaterialPageRoute(
//                                            builder: (context) => SearchMedicine(generic_name: body['results'][0]['generic_name'],
//                                              brand_name: body['results'][0]['brand_name'],
//                                              dosage_form: body['results'][0]['dosage_form'],
//                                              labeler_name: body['results'][0]['labeler_name'],
//                                            )
//                                        ),
//                                      );
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => SearchMedicine(
                                            list: a, b: b, c: c, d: d)));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Medicine not found'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            },
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  CardCategory(
                      title: "Medicines",
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
                                        title: Text(data[index].generic_name),
                                        subtitle: Text('Brand Name: ' +
                                            data[index].brand_name +
                                            '\n' +
                                            'Dosage Form ' +
                                            data[index].dosage_form +
                                            '\n' +
                                            'Label Company: ' +
                                            data[index].labeler_name +
                                            '\n'),
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
