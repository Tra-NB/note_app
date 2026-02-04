import 'package:flutter/material.dart';
import 'app_colors.dart'; 

class AppTheme {
  static const TextTheme myTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText, 
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      height: 1.5,
      color: AppColors.darkText,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.5,
      color: AppColors.greyText,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      letterSpacing: 1.2,
      color: AppColors.greyText,
    ),
  );

  static TextStyle filterChipStyle(BuildContext context, bool selected) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: selected ? AppColors.whiteText : AppColors.darkText,
      fontWeight: FontWeight.normal,
    );
  }

  static List<BoxShadow> commonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4), 
    ),
  ];

}