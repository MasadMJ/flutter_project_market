import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename;
import '../screens/verify_email.dart';
import '../shared/snackbar.dart';

final userINFO = FirebaseAuth.instance.currentUser!;
final userDB = FirebaseFirestore.instance.collection('users');


registerToFireBase(
    context, emailAddress, password, username, title, age, imgPath) async {
  try {
    final userINFO = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    String imgUrlUploaded = await uploadImgToFirestore(imgPath);
    saveDataToStore(userINFO.user!.uid, emailAddress, password, username, title,
        age, imgUrlUploaded);
    showSnackBar(context, "Account Created");
    loginWithFireBase(context, emailAddress, password);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Login()));
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
        context, MaterialPageRoute(builder: (context) => const VerifyEmailView()));
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

saveDataToStore(uid, email, password, username, title, age, imgURL) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users
      .doc(uid)
      .set({
        'email': email,
        'password': password,
        'imgURL': imgURL,
        'username': username,
        'age': age,
        'title': title,
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

uploadImgToFirestore(String ImgPath) async {
  String imgName = basename(ImgPath);
  int random = Random().nextInt(9999999);
  imgName = "$random$imgName";
  final storageRef = FirebaseStorage.instance.ref("users-img/${imgName}");
  await storageRef.putFile(File(ImgPath!));
  String url = await storageRef.getDownloadURL();
  return url;
}

//Delete a field in document [firestore]
deleteField(field) {
  userDB.doc(userINFO!.uid).update({field: FieldValue.delete()});
}

replaceIMG(String ImgPath) async {
  String url = await uploadImgToFirestore(ImgPath);
  userDB.doc(userINFO!.uid).update({"imgURL": url});
}

//Delete a document [firestore]
deleteDocAllDoc() {
  userDB.doc(userINFO!.uid).delete();
}

//Delete user [firebase auth]
deleteFirebaseAuth() {
  userINFO!.delete();
}

Future<dynamic> getFieldFromDocument(
    String documentId, String fieldName) async {
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
