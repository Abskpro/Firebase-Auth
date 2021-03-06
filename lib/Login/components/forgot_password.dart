import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeroday/Components/email_input.dart';
import 'package:zeroday/Components/reset_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeroday/Login/login_screen.dart';
import 'package:zeroday/bloc/resetBloc/reset_bloc.dart';
import 'package:zeroday/bloc/resetBloc/reset_event.dart';
import 'package:zeroday/bloc/resetBloc/reset_state.dart';
import 'package:zeroday/repositories/user_repository.dart';

class ForgotPassword extends StatefulWidget {
  final UserRepository userRepository;
  ForgotPassword({this.userRepository});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  ResetBloc resetBloc;
  TextEditingController emailController;

  void initState() {
    super.initState();
    resetBloc = ResetBloc(userRepository: widget.userRepository);
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

  void onChanged(type, value) {
    print(value);
    if (type == "email") {
      setState(() {
        email = value;
      });
    }
  }

  bool validateEmail({checkEmpty: false}) {
    return (email.isEmpty && !checkEmpty) ||
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  void validate() {
    print(email);
    resetBloc.add(PasswordResetPressed(email: email.toString()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<ResetBloc>(
      create: (BuildContext context) => resetBloc,
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: BlocConsumer<ResetBloc, ResetState>(listener: (context, state) {
          print("state has changed $state");
          if (state is PasswordResetEmailSentState) {
            // Navigator.pop(context);
            // Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(userRepository: widget.userRepository)),
                (Route<dynamic> route) => false);
            Fluttertoast.showToast(
              msg: "Email reset link has been sent to your mail",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0,
            );
          }
          if (state is PasswordResetLoadingState) {
            showAlertDialog(context);
          }
          if (state is PasswordResetEmailFailedState) {
            print("this is the reset stage ${state.message}");
            Navigator.pop(context);
            List<String> part = state.message.split(' ');
            part.remove('Exception:');
            String errorMessage = part.join(' ');
            Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0,
            );
          }
        }, builder: (context, state) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Your Email ',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  EmailInput(
                    controller: emailController,
                    validate: validateEmail,
                    onChanged: onChanged,
                  ),
                  ResetButton(
                    validateEmail: validateEmail,
                    press: validate,
                    text: "RESET",
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
