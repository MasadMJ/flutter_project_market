// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../shared/checks.dart';
import '../shared/colors.dart';
import '../shared/constant.dart';
import '../firebase/firebase.dart';
import '../shared/snackbar.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final emaillController = TextEditingController();
  final passwordController = TextEditingController();
  final titleController = TextEditingController();
  final ageController = TextEditingController();
  final usernameController = TextEditingController();
  String? imgPath;
  bool uppercase = false;
  bool digits = false;
  bool lowercase = false;
  bool min8Characters = false;
  bool specialCharacters = false;
  bool isLoadding = false;
  bool showPassword = false;
  bool passedPasswordCHECK = false;

  @override
  void dispose() {
    emaillController.dispose();
    passwordController.dispose();
    ageController.dispose();
    usernameController.dispose();
    titleController.dispose();
    super.dispose();
  }

  passCheckInTime(String password) {
    setState(() {
      uppercase = hasUppercase(password);
      digits = hasDigits(password);
      lowercase = hasLowercase(password);
      min8Characters = hasMin8Characters(password);
      specialCharacters = hasSpecialCharacters(password);
      passedPasswordCHECK = specialCharacters &&
          lowercase &&
          uppercase &&
          digits &&
          min8Characters;
    });
  }

  uploadImage2Screen(type) async {
    final pickedImg = await ImagePicker().pickImage(source: type);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = pickedImg.path;
        });
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
        backgroundColor: appbarGreen,
        centerTitle: false,
        title: Text("Register"),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          //color: Color.fromARGB(0, 255, 255, 255),
          image: DecorationImage(
              image: AssetImage("lib/assets/img/main_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: Stack(
                        children: [
                          (imgPath == null)
                              ? CircleAvatar(
                                  backgroundImage:
                                      AssetImage("lib/assets/img/avatar.png"),
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                )
                              : ClipOval(
                                  child: Image.file(
                                  File(imgPath!),
                                  fit: BoxFit.cover,
                                  width: 130,
                                  height: 130,
                                )),
                          Positioned(
                              right: -12,
                              bottom: -15,
                              child: IconButton(
                                  onPressed: () async {
                                    await showmodel();
                                    //  Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.photo_camera,
                                    size: 30,
                                  )))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: usernameController,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: const Icon(Icons.person),
                            hintText: "Enter your Username")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        controller: ageController,
                        textInputAction: TextInputAction.next,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: const Icon(Icons.face),
                            hintText: "Enter your age")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: const Icon(Icons.title),
                            hintText: "Enter your title")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        validator: (value) {
                          return value != null && !emailVaild(value)
                              ? "Enter a valid email"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: emaillController,
                        textInputAction: TextInputAction.next,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: const Icon(Icons.email),
                            hintText: "Enter your Email")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        onChanged: (value) {
                          passCheckInTime(value);
                        },
                        obscureText: showPassword ? false : true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: passwordController,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      )
                                    : const Icon(Icons.visibility_off)),
                            hintText: "Enter your Password")),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 25,
                      child: checkWidgetPassword(
                          min8Characters, "At least 8 characters"),
                    ),
                    SizedBox(
                      height: 25,
                      child: checkWidgetPassword(digits, "At least 1 number"),
                    ),
                    SizedBox(
                      height: 25,
                      child: checkWidgetPassword(uppercase, "Has Uppercase"),
                    ),
                    SizedBox(
                      height: 25,
                      child: checkWidgetPassword(lowercase, "Has  Lowercase"),
                    ),
                    SizedBox(
                      height: 25,
                      child: checkWidgetPassword(
                          specialCharacters, "Has  Special Characters"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            passedPasswordCHECK) {
                          setState(() {
                            isLoadding = !isLoadding;
                          });
                          await registerToFireBase(
                              context,
                              emaillController.text,
                              passwordController.text,
                              usernameController.text,
                              titleController.text,
                              ageController.text,
                              imgPath);
                          setState(() {
                            isLoadding = !isLoadding;
                          });
                        } else {
                          showSnackBar(context, "Error in deatils");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(bTNgreen),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(15)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      child: isLoadding
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Register",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        "Do you have an account?",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: const Text('Sign in',
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
