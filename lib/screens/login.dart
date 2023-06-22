import 'dart:io';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../shared/colors.dart';
import '../shared/constant.dart';
import '../shared/firebase.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emaillController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoadding = false;
  bool showPassword = false;

  @override
  void dispose() {
    emaillController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // color: Color.fromARGB(0, 255, 255, 255),
          image: DecorationImage(
              image: AssetImage("lib/assets/img/main_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? "Enter a valid email"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: emaillController,
                  decoration: decorationTextFiled.copyWith(
                      suffixIcon: const Icon(Icons.email),
                      hintText: "Write your Email")),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  obscureText: showPassword ? false : true,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: decorationTextFiled.copyWith(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: showPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      hintText: "Write your Password")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoadding = !isLoadding;
                  });
                  await loginWithFireBase(
                      context, emaillController.text, passwordController.text);
                  setState(() {
                    isLoadding = !isLoadding;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(bTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoadding
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Do not have an account?",
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: const Text('Sign up',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
