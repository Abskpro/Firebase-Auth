import 'package:flutter/material.dart';
import 'package:zeroday/Components/social_media_button.dart';

class SocialLink extends StatelessWidget {
  final Function google;
  final Function facebook;

  SocialLink({this.google, this.facebook});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
            text: "Facebook",
            textColor: Colors.white,
            bgColor: Colors.blue,
            press: facebook),
        SizedBox(
          width: 20,
        ),
        SocialButton(
          text: "Google",
          textColor: Colors.white,
          bgColor: Colors.redAccent,
          press: google,
        ),
      ],
    );
  }
}
