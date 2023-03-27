class Med {
  final String id;
  final String generic_name;
  final String brand_name;
  final String labeler_name;
  final String dosage_form;


  Med({this.id,this.generic_name, this.brand_name,this.labeler_name,this.dosage_form});

  factory Med.fromJson(Map<String, dynamic> json) {
    return Med(
      id:json['id'].toString(),
      generic_name: json['generic_name'],

      brand_name: json['brand_name'],
      labeler_name:json['labeler_name'],
      dosage_form:json['dosage_form'],
    );
  }
}