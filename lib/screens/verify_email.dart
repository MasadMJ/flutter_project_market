import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/home.dart';
import 'package:flutter_project_market/screens/login.dart';
import 'package:flutter_project_market/shared/snackbar.dart';

import '../shared/colors.dart';
import '../shared/firebase.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Duration timeResendEnable = const Duration(minutes: 1);
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  Timer? timer2;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
    //  sendVerificationEmail(context);

      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        // when we click on the link that existed on yahoo
        await FirebaseAuth.instance.currentUser!.reload();

        // is email verified or not (clicked on the link or not) (true or false)
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isEmailVerified) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  timerResend() {
    timer2 = Timer.periodic(timeResendEnable, (timer) {
      canResendEmail = !canResendEmail;
      timer.cancel();
    });
  }

  resendEmail() async {
    setState(() {
      canResendEmail = false;
    });
    // await sendVerificationEmail(
    //   context,
    // );
    showSnackBar(context, "Email Resent");
    timerResend();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
              elevation: 0,
              backgroundColor: appbarGreen,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent to your email",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (timer2 == null) {
                        timerResend();
                      }
                      canResendEmail
                          ? resendEmail()
                          : showSnackBar(context,
                              "Please wait ${timeResendEnable.inMinutes} Minutes and try again");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(bTNgreen),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  TextButton(
                    onPressed: () async {
                      await logOutFireBase();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(bTNpink),
                    //   padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    //   shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8))),
                    // ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
