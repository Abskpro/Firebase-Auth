import 'package:flutter/material.dart';

class SignUpButton extends StatefulWidget {
  final TextEditingController controller;
  final Function validate;
  final Function onChanged;
  final Function validateEmail;
  final Function validatePassword;
  final Function validateConfirmPassword;
  final Function validateNumber;
  final Color color, textColor;
  final String text;
  final Function press;
  const SignUpButton(
      {Key key,
      this.controller,
      this.validate,
      this.onChanged,
      this.color,
      this.press,
      this.validateEmail,
      this.validatePassword,
      this.validateNumber,
      this.validateConfirmPassword,
      this.text,
      this.textColor});
  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.5,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: RaisedButton(
                color: Colors.lightGreen,
                onPressed: widget.validateEmail(checkEmpty: true) &&
                        widget.validatePassword(checkEmpty: true) &&
                        widget.validateNumber(checkEmpty: true) &&
                widget.validateConfirmPassword(checkEmpty: true)
                    ? widget.press
                    : null,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Text(
                  widget.text,
                  style: TextStyle(color: widget.textColor),
                ))));
  }
}
