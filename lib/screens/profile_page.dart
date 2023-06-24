// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project_market/firebase/firebase.dart';
import 'package:image_picker/image_picker.dart';

import '../firebase/data_firestore.dart';
import '../firebase/img_firestore.dart';
import '../shared/colors.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  final dataFirestore = GetDataFromFirestore(getAuthInfo("uid"));
  File? imgPath;

  uploadImage2Screen(type) async {
    final pickedImg = await ImagePicker().pickImage(source: type);
    try {
      if (pickedImg != null) {
        imgPath = await replaceIMG(pickedImg.path);
        setState(() {});
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pop(context);
            },
            label: Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: Text("Profile Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                   // width: 50,
                    padding: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // (imgPath == null)
                        //     ? CircleAvatar(
                        //         backgroundImage:
                        //             AssetImage("lib/assets/img/avatar.png"),
                        //         backgroundColor: Colors.white,
                        //         radius: 60,
                        //       )
                        //     :

                        GetImgFromFirestore(getAuthInfo("uid")),

                        // : ClipOval(
                        //     child: Image.file(
                        //     imgPath!,
                        //     fit: BoxFit.cover,
                        //     width: 130,
                        //     height: 130,
                        //   )),
                        
                      ],
                    ),
                  ),
                   IconButton(icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showmodel();
                                    }),
                ],
              ),
              
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Container(
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: Text(
                  "Info from firebase Auth",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Email: ${getAuthInfo("email")}   ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Created date: ${getAuthInfo("created")}      ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Last Signed In:${getAuthInfo("lastsignin")} ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              deleteFirebaseAuth();
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Delete Account",
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline))))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 131, 177, 255),
                          borderRadius: BorderRadius.circular(11)),
                      child: Text(
                        "Info from firebase firestore",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
              dataFirestore,
            ],
          ),
        ),
      ),
    );
  }
}
