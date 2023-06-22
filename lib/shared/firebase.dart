import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/home.dart';

import '../screens/login.dart';
import 'snackbar.dart';

registerToFireBase(context, emailAddress, password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    showSnackBar(context, "Account Created");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  } on FirebaseAuthException catch (e) {
    late String error;
    if (e.code == 'weak-password') {
      error = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      error = 'The account already exists for that email.';
    } else {
      error = "Unknown Error ${e.code}";
    }
    showSnackBar(context, error);
  }
}

loginWithFireBase(context, emailAddress, password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  } on FirebaseAuthException catch (e) {
    late String error;
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

logOutFireBase(context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Login()));
}