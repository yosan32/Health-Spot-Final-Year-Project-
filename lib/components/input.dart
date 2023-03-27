import 'package:flutter/material.dart';
import 'package:now_ui_flutter/components/textfield.dart';



class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Function validator;
  final TextEditingController controller;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            height: 1,
          ),
          hintText: hintText,
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}