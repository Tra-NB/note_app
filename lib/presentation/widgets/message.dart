import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/presentation/theme/app_colors.dart';

class ToastMessage {
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP, 
      backgroundColor: AppColors.background,
      textColor: AppColors.darkText,
      fontSize: 14.0,
    );
  }

  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}