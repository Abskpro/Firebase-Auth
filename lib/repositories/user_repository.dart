import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserRepository {
  FirebaseAuth firebaseAuth;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

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
      switch (e.code) {
        case 'email-already-in-use':
          authError = "Email is already in use";
          break;
        case 'network-error':
          authError = "Network Error";
          break;
        case 'network-error':
          authError = "There is problem with the connection";
          break;
        case 'too-many-requests':
          authError = "Too many request";
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
      switch (e.code) {
        case 'user-not-found':
          authError = "User does'nt exists.";
          break;
        case 'wrong-password':
          authError = "Wrong Password";
          break;
        case 'network-error':
          authError = "There is problem with the connection";
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

  Future<User> signInWithGoogle() async {
    print("Goooogle");
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);
    return await firebaseAuth.currentUser;
  }

  Future<User> signInWithFacebook() async {
    // final FacebookLogin fbLogin = new FacebookLogin();
    // final FacebookLoginResult facebookLoginResult =
    //     await fbLogin.logIn(['email', 'public_profile']);
    // if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
    //   FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    //   print(facebookAccessToken);
    //   // return await firebaseAuth.currentUser;
    // }

    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);
      FacebookAccessToken myToken = result.accessToken;

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(myToken.token);
        final User user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        //print('signed in ' + user.displayName);
        // return user;
        return await firebaseAuth.currentUser;
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> logOut() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future<User> getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    } catch (e) {
      print("exception gnin ${e.message}");
      print("exception code ${e.code}");
      String resetMessage = "";
      switch (e.code) {
        case 'user-not-found':
          resetMessage = "Email does'nt exists";
          break;
        default:
          print("Case ${e.message} is not yet implemented");
      }
      throw Exception(resetMessage);
    }
  }
}
