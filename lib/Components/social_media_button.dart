import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Function press;
  final Color bgColor;
  SocialButton({Key key, this.press, this.bgColor, this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: RaisedButton(
                color: bgColor,
                onPressed: press,
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ))));
  }
}
