import 'package:flutter/material.dart';
import 'package:zeroday/Signup/components/body.dart';
import 'package:zeroday/repositories/user_repository.dart';

class SignUpScreen extends StatelessWidget {
  final UserRepository userRepository;
  SignUpScreen({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        userRepository: userRepository,
      ),
    );
  }
}
