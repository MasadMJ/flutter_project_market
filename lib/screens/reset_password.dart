import 'package:flutter/material.dart';
import 'package:flutter_project_market/shared/firebase.dart';
import 'package:flutter_project_market/shared/snackbar.dart';
import '../shared/checks.dart';
import '../shared/colors.dart';
import '../shared/constant.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final emaillController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoadding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        centerTitle: false,
        title: Text("Reset password"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  controller: emaillController,
                  decoration: decorationTextFiled.copyWith(
                      suffixIcon: const Icon(Icons.email),
                      hintText: "Write your Email")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoadding = !isLoadding;
                  });
                  if (_formKey.currentState!.validate()) {
                    String b =
                        await resetPasswordFireBase(emaillController.text);
                    if (!mounted) return;
                    showSnackBar(context, b);
                  } else {
                    showSnackBar(context, "Error");
                  }
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
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Reset",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
