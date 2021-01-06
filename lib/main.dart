import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeroday/Login/login_screen.dart';
import 'package:zeroday/bloc/authBloc/auth_bloc.dart';
import 'package:zeroday/bloc/authBloc/auth_event.dart';
import 'package:zeroday/bloc/authBloc/auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zeroday/bloc/homeBloc/home_state.dart';
import 'package:zeroday/bloc/resetBloc/reset_state.dart';
import 'package:zeroday/landing/landing_screen.dart';
import 'package:zeroday/repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  UserRepository _repository = UserRepository();
  runApp(MyApp(
    userRepository: _repository,
  ));
}

class MyApp extends StatelessWidget {
  UserRepository userRepository;
  MyApp({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
            create: (context) => AuthBloc(userRepository: userRepository)
              ..add(AppStartedEvent()),
            child: App(userRepository: userRepository)));
  }
}

class App extends StatelessWidget {
  UserRepository userRepository;

  App({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state);
        if (state is AuthInitialState || state is LogOutSuccessState) {
          return LoginScreen(userRepository: userRepository);
        } else if (state is AuthenticatedState) {
          return LandingPage(user: state.user, userRepository: userRepository);
        } else if (state is UnauthenticatedState ||
            state is LogOutSuccessState) {
          return LoginScreen(userRepository: userRepository);
        } else if (state is PasswordResetEmailSentState) {
          return LoginScreen(userRepository: userRepository);
        }
      },
    );
  }
}
