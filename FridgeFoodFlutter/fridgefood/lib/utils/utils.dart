import 'package:flutter/material.dart';

class Utils {
  // USE : Utils.snackBar('No Internet', context)
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
