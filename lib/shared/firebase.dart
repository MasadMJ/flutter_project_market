import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/home.dart';

import '../screens/login.dart';
import '../screens/verify_email.dart';
import 'snackbar.dart';

String myerror = "keychain-error";
registerToFireBase(context, emailAddress, password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    showSnackBar(context, "Account Created");
    loginWithFireBase(context, emailAddress, password);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Login()));
  } on FirebaseAuthException catch (e) {
    late String error;
    if (e.code == myerror) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    if (e.code == 'weak-password') {
      error = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      error = 'The account already exists for that email.';
    } else {
      error = "Unknown Error ${e.code}";
      print("${e.code}");
    }
    showSnackBar(context, error);
  }
}

loginWithFireBase(context, emailAddress, password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const VerifyEmailView()));
  } on FirebaseAuthException catch (e) {
    late String error;
    if (e.code == myerror) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
    if (e.code == 'user-not-found') {
      error = ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      error = ('Wrong password provided for that user.');
    } else {
      error = "Unknown Error ${e.code}";
    }
    showSnackBar(context, error);
  }
}

logOutFireBase() async {
  await FirebaseAuth.instance.signOut();
}

resetPasswordFireBase(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return "Rest Email sent";
  } catch (e) {
    return e.toString();
  }
}

sendVerificationEmail(context) async {
  try {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    await Future.delayed(Duration(seconds: 5));
  } catch (e) {
    print(e);
    showSnackBar(context, e.toString());
  }
}
