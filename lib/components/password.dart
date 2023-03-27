import 'package:flutter/material.dart';
import 'package:now_ui_flutter/components/textfield.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Function validator;
  final TextEditingController controller;
  const RoundedPasswordField({
    Key key,
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
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Password",
          border: InputBorder.none,
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}