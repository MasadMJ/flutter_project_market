import 'package:flutter/material.dart';

const decorationTextFiled = InputDecoration(
  // To delete borders
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
  ),
  // fillColor: Colors.red,
  filled: true,
  contentPadding: EdgeInsets.all(8),
);



 var  buttonStyle = ButtonStyle(
     backgroundColor: MaterialStateProperty.all(Colors.orange),
     padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  );

