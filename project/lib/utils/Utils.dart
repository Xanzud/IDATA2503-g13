import 'package:flutter/material.dart';

class Utils {
  static var messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, MaterialColor? color) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: color);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
