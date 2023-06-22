import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          //color: Color.fromARGB(0, 255, 255, 255),
          image: DecorationImage(
              image: AssetImage("lib/assets/img/main_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      decoration: decorationTextFiled.copyWith(
                          suffixIcon: const Icon(Icons.person),
                          hintText: "Enter your Username")),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      validator: (value) {
                        return value != null && !EmailValidator.validate(value)
                            ? "Enter a valid email"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emaillController,
                      decoration: decorationTextFiled.copyWith(
                          suffixIcon: const Icon(Icons.email),
                          hintText: "Enter your Email")),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      validator: (value) {
                        return value!.length < 8
                            ? "Password less 8 charcters"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: showPassword ? false : true,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
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
                          hintText: "Enter your Password")),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoadding = !isLoadding;
                        });
                        await registerToFireBase(context, emaillController.text,
                            passwordController.text);
                      } else {
                        showSnackBar(context, "Error in deatils");
                      }
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
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Register",
                            style: TextStyle(fontSize: 19),
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
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
