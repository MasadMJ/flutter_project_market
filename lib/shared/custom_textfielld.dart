// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextFiled extends StatelessWidget {
  final bool isPassword;
  final TextInputType textType;
  final String hintText;

  const MyTextFiled(
      {super.key,
      required this.isPassword,
      required this.textType,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: textType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          // To delete borders
          enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          // fillColor: Colors.red,
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ));
  }
}
