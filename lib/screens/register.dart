// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../shared/checks.dart';
import '../shared/colors.dart';
import '../shared/constant.dart';
import '../shared/firebase.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: decorationTextFiled.copyWith(
                            suffixIcon: const Icon(Icons.person),
                            hintText: "Enter your Username")),
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
                          await registerToFireBase(context,
                              emaillController.text, passwordController.text);
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
