import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/home.dart';

import '../screens/login.dart';
import '../screens/verify_email.dart';
import 'snackbar.dart';

final userINFO = FirebaseAuth.instance.currentUser!;
  final userDB =
      FirebaseFirestore.instance.collection('users');

String myerror = "keychain-error";
registerToFireBase(
    context, emailAddress, password, username, title, age) async {
  try {
    final userINFO = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    
    );
    saveData(userINFO.user!.uid, emailAddress, password, username, title, age);
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
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
    await userINFO.sendEmailVerification();
    await Future.delayed(Duration(seconds: 5));
  } catch (e) {
    print(e);
    showSnackBar(context, e.toString());
  }
}

getAuthInfo(type) {
  switch (type) {
    case "email":
      return userINFO.email;
    case "name":
      return userINFO.displayName;
    case "photo":
      return userINFO.photoURL;
    case "uid":
      return userINFO.uid;
    case "created":
      return DateFormat("MMMM d, y").format(userINFO!.metadata.creationTime!);
    case "lastsignin":
      return DateFormat("MMMM d, y").format(userINFO!.metadata.lastSignInTime!);

    default:
      return "no data";
  }
}

saveData(uid, email, password, username, title, age) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users
      .doc(uid)
      .set({
        'email': email,
        'password': password,
        'username': username,
        'age': age,
        'title': title
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}


//Delete a field in document [firestore]
deleteField(field)  {
     userDB.doc(userINFO!.uid).update({field: FieldValue.delete()});
}


//Delete a document [firestore]
deleteDocAllDoc()  {
  userDB.doc(userINFO!.uid).delete();
}

//Delete user [firebase auth]
deleteFirebaseAuth()  {
     userINFO!.delete();
}







Future<dynamic> getFieldFromDocument(String documentId, String fieldName) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(fieldName)) {
        dynamic fieldValue = data[fieldName];
        return fieldValue;
      } else {
        return null; // Field doesn't exist
      }
    } else {
      return null; // Document doesn't exist
    }
  } catch (e) {
    return null; // Something went wrong
  }
}
