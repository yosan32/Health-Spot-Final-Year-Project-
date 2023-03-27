import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final Function onTap;
  final Function onChanged;
  final bool pass;
  final TextEditingController controller;
  final bool autofocus;
  final Color borderColor;

  Input(
      {this.placeholder,
      this.suffixIcon,
      this.prefixIcon,
      this.onTap,
        this.pass=false,
      this.onChanged,
      this.autofocus = false,
      this.borderColor = NowUIColors.border,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
        cursorColor: NowUIColors.muted,
        onTap: onTap,
        obscureText:pass,
        onChanged: onChanged,
        controller: controller,
        autofocus: autofocus,
        style: TextStyle(height: 1, fontSize: 13.0, color: NowUIColors.time),
        textAlignVertical: TextAlignVertical(y: 0.3),
        decoration: InputDecoration(
            filled: true,
            fillColor: NowUIColors.white,
            hintStyle: TextStyle(
              color: NowUIColors.time,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            hintText: placeholder));
  }
}
