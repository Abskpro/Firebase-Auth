import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object> get props => null;
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => null;
}

class LoginSuccessState extends LoginState {
  User user;

  LoginSuccessState(@required this.user);

  @override
  List<Object> get props => null;
}

class LoginFailState extends LoginState {
  String message;

  LoginFailState(@required this.message);

  @override
  List<Object> get props => null;
}
