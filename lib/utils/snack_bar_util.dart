// lib/utils/snackbar_utils.dart

import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
