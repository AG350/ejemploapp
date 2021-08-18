import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger(
        child: Text(message),
      );
}
