import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeroday/Components/email_input.dart';
import 'package:zeroday/Components/number_input.dart';
import 'package:zeroday/Components/password_input.dart';
import 'package:zeroday/Components/signup_button.dart';
import 'package:zeroday/Signup/components/background.dart';
import 'package:zeroday/bloc/regBloc/reg_bloc.dart';
import 'package:zeroday/bloc/regBloc/reg_event.dart';
import 'package:zeroday/bloc/regBloc/reg_state.dart';
import 'package:zeroday/repositories/user_repository.dart';

class Body extends StatefulWidget {
  final UserRepository userRepository;
  Body({this.userRepository});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  UserRegBloc userRegBloc;

  String email = "";
  String password = "";
  String confirmPassword = "";
  String number = "";
  String error = '';

  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  TextEditingController numberController;

  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    numberController = TextEditingController();
    confirmPasswordController = TextEditingController();

    emailController.addListener(_updateEmail);
    passwordController.addListener(_updatePassword);
    confirmPasswordController.addListener(_updateConfirmPassword);
    numberController.addListener(_updateNumber);

    userRegBloc = UserRegBloc(userRepository: widget.userRepository);
  }

  void onChanged(type, value) {
    print(value);
    if (type == "email") {
      setState(() {
        email = value;
      });
    } else if (type == "password") {
      setState(() {
        password = value;
      });
    } else if (type == "number") {
      setState(() {
        number = value;
      });
    } else if (type == "confirmPassword") {
      setState(() {
        confirmPassword = value;
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

  _updateConfirmPassword() {
    print("updated");
    setState(() {
      confirmPassword = confirmPasswordController.text;
    });
  }

  _updateNumber() {
    print("updated");
    setState(() {
      number = numberController.text;
    });
  }

  bool validateEmail({checkEmpty: false}) {
    print("validating email");
    return (email.isEmpty && !checkEmpty) ||
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  bool validatePassword({checkEmpty: false}) {
    // print("validating password");
    return (password.isEmpty && !checkEmpty) || password.length > 8;
    // return true;
  }

  bool validateNumber({checkEmpty: false}) {
    print("validating number");
    return (number.isEmpty && !checkEmpty) ||
        number.length == 10 ||
        RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
            .hasMatch(number);
  }

  bool validateConfirmPassword({checkEmpty: false}) {
    print("validating confirm password");
    print(confirmPassword);
    print(password);
    return (confirmPassword.isEmpty && !checkEmpty) ||
        confirmPassword == password;
  }

  void validate() async {
    userRegBloc.add(SignUpButtonPressed(email: email, password: password));
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
    // Size size = MediaQuery.of(context).size;
    return BlocProvider<UserRegBloc>(
      create: (BuildContext context) => userRegBloc,
      child: Background(
          child: SingleChildScrollView(
        child:
            BlocConsumer<UserRegBloc, UserRegState>(listener: (context, state) {
          if (state is UserRegSuccessful) {
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "Registered Please login",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0,
            );
          } else if (state is UserRegFailure) {
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
          } else if (state is UserRegLoading) {
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
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Image.asset(
                      "assets/images/register.png",
                      height: 200,
                    ),
                  ),
                  EmailInput(
                    controller: emailController,
                    validate: validateEmail,
                    onChanged: onChanged,
                  ),
                  NumberInput(
                    controller: numberController,
                    validate: validateNumber,
                    onChanged: onChanged,
                  ),
                  PasswordInput(
                    text: "Password",
                    controller: passwordController,
                    type: "password",
                    isConfirm: false,
                    validate: validatePassword,
                    onChanged: onChanged,
                  ),
                  PasswordInput(
                    text: "Confim Password",
                    type: "confirmPassword",
                    screen: "Signup",
                    controller: confirmPasswordController,
                    validate: validateConfirmPassword,
                    onChanged: onChanged,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SignUpButton(
                    validateEmail: validateEmail,
                    validatePassword: validatePassword,
                    validateNumber: validateNumber,
                    validateConfirmPassword: validateConfirmPassword,
                    press: validate,
                    text: "Register",
                    color: Colors.blue,
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
