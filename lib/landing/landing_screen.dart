import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeroday/Login/login_screen.dart';
import 'package:zeroday/bloc/homeBloc/home_bloc.dart';
import 'package:zeroday/bloc/homeBloc/home_event.dart';
import 'package:zeroday/bloc/homeBloc/home_state.dart';
import 'package:zeroday/models/interns.dart';
import 'package:provider/provider.dart';
import 'package:zeroday/repositories/user_repository.dart';

class LandingPage extends StatefulWidget {
  // final AuthService _auth = AuthService();
  User user;
  UserRepository userRepository;
  LandingPage({this.user, this.userRepository});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  HomePageBloc homePageBloc;

  void initState() {
    super.initState();
    homePageBloc = HomePageBloc(userRepository: widget.userRepository);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user);
    print(widget.userRepository);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text("Landing Page"),
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                onPressed: () {
                  homePageBloc.add(LogOutEvent());
                },
                label: Text('logout'),
              )
            ],
          ),
          body: BlocProvider<HomePageBloc>(
            create: (BuildContext context) => homePageBloc,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<HomePageBloc, HomePageState>(
                  listener: (context, state) {
                    if (state is LogOutSuccessState) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return LoginScreen(
                            userRepository: widget.userRepository);
                      }));
                    }
                  },
                  builder: (context, state) {
                    print("${widget.user.metadata}");
                    var email = widget.user.email;
                    var uid = widget.user.uid;
                    var lastSignIn = widget.user.metadata.lastSignInTime;
                    return Container(
                      alignment: Alignment.center,
                      child:Card(
                        child: Column(
                          children: [Text("Email: $email",style: TextStyle(fontWeight: FontWeight.bold),), Text("Id: $uid",style: TextStyle(fontWeight: FontWeight.bold),),Text("LastSignIn:$lastSignIn", style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
}
