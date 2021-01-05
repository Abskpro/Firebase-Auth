import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeroday/Components/email_input.dart';
import 'package:zeroday/Components/password_input.dart';
import 'package:zeroday/Components/rounded_button.dart';
import 'package:zeroday/Login/components/background.dart';
import 'package:zeroday/Login/components/forgot_password.dart';
import 'package:zeroday/Login/components/social_media.dart';
import 'package:zeroday/Signup/signup_screen.dart';
import 'package:zeroday/bloc/loginBloc/login_bloc.dart';
import 'package:zeroday/bloc/loginBloc/login_event.dart';
import 'package:zeroday/bloc/loginBloc/login_state.dart';
import 'package:zeroday/landing/landing_screen.dart';
import 'package:zeroday/repositories/user_repository.dart';

class Body extends StatefulWidget {
  final UserRepository userRepository;
  Body({this.userRepository});
  @override
  _BodyState createState() {
    return new _BodyState();
  }
}

class _BodyState extends State<Body> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  LoginBloc loginBloc;

  String email = "";
  String password = "";
  TextEditingController emailController;
  TextEditingController passwordController;

  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(_updateEmail);
    passwordController.addListener(_updatePassword);
    loginBloc = LoginBloc(userRepository: widget.userRepository);
  }

  void onChanged(type, value) {
    print(value);
    if (type == "email") {
      setState(() {
        email = value;
      });
    } else {
      setState(() {
        password = value;
      });
    }
  }

  _updateEmail() {
    print("updated");
    setState(() {
      email = emailController.text;
    });
  }

  _updatePassword() {
    print("updated");
    setState(() {
      password = passwordController.text;
    });
  }

  bool validateEmail({checkEmpty: false}) {
    return (email.isEmpty && !checkEmpty) ||
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  bool validatePassword({checkEmpty: false}) {
    return (password.isEmpty && !checkEmpty) || password.length > 8;
  }

  void validate() async {
    loginBloc.add(LoginButtonPressed(email: email, password: password));
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading"))
      ],
    ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => loginBloc,
      child: Background(
          child: SingleChildScrollView(
        child: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LandingPage(
                  user: state.user, userRepository: widget.userRepository);
            }));
          }
          if (state is LoginFailState) {
            Navigator.pop(context);
            print("error >> ${state.message}");
            // setState(() {
            List<String> part = state.message.split(' ');
            part.remove('Exception:');
            String errorMessage = part.join(' ');
            // });
            Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0,
            );
          }
          if (state is LoginLoadingState) {
            showAlertDialog(context);
          }
        }, builder: (context, state) {
          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Image.asset("assets/images/login_img.png"),
                  ),
                  EmailInput(
                    controller: emailController,
                    validate: validateEmail,
                    onChanged: onChanged,
                  ),
                  PasswordInput(
                    text: "Password",
                    screen: "login",
                    type: "password",
                    controller: passwordController,
                    validate: validatePassword,
                    onChanged: onChanged,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 50.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgotPassword(
                                userRepository: widget.userRepository);
                          }));
                        },
                        child: Text(
                          "Forgot password?",
                        )),
                  ),
                  RoundedButton(
                    validateEmail: validateEmail,
                    validatePassword: validatePassword,
                    press: validate,
                    text: "LOG IN",
                    color: Colors.blue,
                  ),
                  SizedBox(height: 15),
                  Text("Or connect using"),
                  SocialLink(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ?"),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignUpScreen(
                                userRepository: widget.userRepository);
                          }));
                        },
                        child: Text('Sign Up'),
                        //  color: Colors.blueAccent,
                        textColor: Colors.blue,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      )),
    );
  }
}
