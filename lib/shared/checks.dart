import 'package:flutter/material.dart';

Widget checkWidgetPassword(bool checked, String text) {
  return Row(
    children: [
      Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: checked ? Colors.green : Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            shape: BoxShape.circle),
        child: const Icon(
          Icons.check,
          size: 15,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        width: 3,
      ),
      Text(text)
    ],
  );
}

bool emailVaild(String email) {
  return email.contains(RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
}

bool hasUppercase(String password) {
  return password.contains(RegExp(r'[A-Z]'));
}

bool hasDigits(String password) {
  return password.contains(RegExp(r'[0-9]'));
}

bool hasLowercase(String password) {
  return password.contains(RegExp(r'[a-z]'));
}

bool hasSpecialCharacters(String password) {
  return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

bool hasMin8Characters(String password) {
  return password.contains(RegExp(r'.{8,}'));
}
