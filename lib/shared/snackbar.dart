import 'package:flutter/material.dart';
 showSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //duration: Duration(days: 1),
      content: Text(message),
      action: SnackBarAction(label: "close", onPressed: () {}),
    ));
 }