import 'package:flutter/material.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      {this.title,
      this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = NowUIColors.text});

  /* @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(top: 6),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: isSelected
                        ? NowUIColors.black.withOpacity(0.07)
                        : Colors.transparent,
                    offset: Offset(0, 0.5),
                    spreadRadius: 3,
                    blurRadius: 10)
              ],
              color: isSelected ? NowUIColors.white : Color(0xff4052c9),
             // borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 22,
                  color: isSelected
                      ? NowUIColors.primary
                      : NowUIColors.white.withOpacity(0.6)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(title,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: isSelected
                            ? Colors.white
                            : NowUIColors.white.withOpacity(0.8))),
              )
            ],
          )),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        child: Center(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Icon(icon,
                  size: 24,
                  color: isSelected
                      ? NowUIColors.primary
                      : Colors.white),
              Text(title,
                  style: TextStyle(
                      letterSpacing: .3,
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: isSelected
                          ? Colors.blue
                          : Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
