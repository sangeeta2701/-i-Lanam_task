import 'package:flutter/material.dart';

class UIComponents {
  static void showSnackBar(BuildContext context, String text, Duration d) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.indigo,
        content: Text(text, style: TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        duration: d,
      ));
  }
}
