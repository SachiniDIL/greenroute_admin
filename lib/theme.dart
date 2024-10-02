import 'package:flutter/material.dart';

class AppColors {
  static const Color buttonColor = Color.fromRGBO(94, 164, 23, 1);
  static const Color primaryColor = Color.fromRGBO(6, 72, 0, 1);
  static const Color backgroundSecondColor = Color.fromRGBO(223, 231, 222, 1);
  static const Color textColor = Color.fromARGB(255, 0, 0, 0);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
}

class AppTextStyles {
  static const TextStyle onboardingText = TextStyle(
    fontFamily: 'poppins',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.backgroundColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonTextLarge = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.backgroundColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle skip = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle topic = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.primaryColor,
    fontSize: 35,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle formText = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.textColor,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
}
