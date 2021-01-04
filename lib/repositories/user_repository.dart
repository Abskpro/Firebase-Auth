import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserRepository {
  FirebaseAuth firebaseAuth;
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserRepository() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<User> signUpUserWithEmailPass(String email, String pass) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return authResult.user;
    } catch (e) {
      // print("exception = ${e.message}");
      print("exception code ${e.code}");
      String authError;
      switch(e.code){
        case 'email-already-in-use': authError = "Email is already in use";
        break;
        case 'network-error': authError = "Network Error";
        break;
        case 'network-error': authError = "There is problem with the connection";
        break;
        case 'too-many-requests': authError = "Too many request";
        break;
        default:
          print("Case ${e.message} is not yet implemented");
          break;
      }
      throw Exception(authError);
    }
  }

  Future<User> signInUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      String authError = "";
      switch(e.code){
        case 'user-not-found': authError = "User does'nt exists.";
        break;
        case 'wrong-password': authError = "Wrong Password";
        break;
        case 'network-error': authError = "There is problem with the connection";
        break;
        default:
          print("Case ${e.message} is not yet implemented");
          break;
      }
      print("exception gnin ${e.message}");
      print("exception code ${e.code}");
      throw Exception(authError);
    }
  }

  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // var result = await _auth.sendPasswordResetEmail(email: email);
    try{
      var result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    }catch(e){
      print("exception gnin ${e.message}");
      print("exception code ${e.code}");
      String resetMessage = "";
      switch(e.code){
        case 'user-not-found': resetMessage = "Email does'nt exists";
        break;
        default:
          print("Case ${e.message} is not yet implemented");
      }
      throw Exception(resetMessage);
    }
  }
}
