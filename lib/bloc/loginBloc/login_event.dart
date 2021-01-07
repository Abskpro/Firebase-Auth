import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginButtonPressed extends LoginEvent {
  String email, password;

  LoginButtonPressed({this.email, this.password});

  @override
  List<Object> get props => throw UnimplementedError();
}

class GoogleButtonPressed extends LoginEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class FacebookButtonPressed extends LoginEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
