import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:zeroday/bloc/loginBloc/login_event.dart';
import 'package:zeroday/bloc/loginBloc/login_state.dart';
import 'package:zeroday/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;

  LoginBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoadingState();
      try {
        var user = await userRepository.signInUser(event.email, event.password);
        print("this is user $user");
        yield LoginSuccessState(user);
      } catch (e) {
        print("error is: ${e.toString()}");
        yield LoginFailState(e.toString());
      }
    }
    if (event is GoogleButtonPressed) {
      yield LoginLoadingState();
      try {
        var user = await userRepository.signInWithGoogle();
        print("fasdfsafsadfasdfasdfasdf $user");
        yield LoginSuccessState(user);
      } catch (e) {
        print("error is: ${e.toString()}");
        yield LoginFailState(e.toString());
      }
    }
    if (event is FacebookButtonPressed) {
      yield LoginLoadingState();
      try {
        var user = await userRepository.signInWithFacebook();
        if (user != null) {
          yield LoginSuccessState(user);
        } else {
          yield LoginInitialState();
        }
      } catch (e) {
        print("error is: ${e.toString()}");
        yield LoginFailState(e.toString());
      }
    }
  }
}
