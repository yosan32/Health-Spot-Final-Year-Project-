import 'package:flutter/material.dart';

RaisedButton(
    {Color textColor,
    Color color,
    VoidCallback onPressed,
    RoundedRectangleBorder shape,
    Padding child}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: child,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      textStyle: TextStyle(color: textColor),
      backgroundColor: color,
    ),
  );
}
