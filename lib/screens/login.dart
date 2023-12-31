

import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/reset_password.dart';
import 'package:flutter_project_market/shared/checks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../provider/google_signin.dart';
import '../shared/colors.dart';
import '../shared/constant.dart';
import '../firebase/firebase.dart';
import 'register.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarGreen,
          centerTitle: false,
          title: const Text("Login"),
        ),
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
                          return value != null && !emailVaild(value)
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
                        await loginWithFireBase(context, emaillController.text,
                            passwordController.text);
                        setState(() {
                          isLoadding = !isLoadding;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(bTNgreen),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      child: isLoadding
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(fontSize: 19),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordView()));
                      },
                      child: const Text('Forgot your password?',
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.white)),
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
                        child: const Text('Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ]),
                    const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 0.6,
                          )),
                          Text(
                            "OR",
                            style: TextStyle(),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 0.6,
                          )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 27),
                      child: GestureDetector(
                        onTap: () {
                          googleSignInProvider.googlelogin();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  // color: Colors.purple,
                                  color: const Color.fromARGB(255, 200, 67, 79),
                                  width: 1)),
                          child: SvgPicture.asset(
                            "lib/assets/icons/google.svg",
                            color: redNice,
                            height: 27,
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
