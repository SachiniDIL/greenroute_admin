import 'package:flutter/material.dart';
import 'package:greenroute_admin/theme.dart';

class BtnSmall extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed; // Add an onPressed callback

  // Constructor to accept the text and onPressed callback
  const BtnSmall({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Use the onPressed callback for the tap event
      child: Container(
        width: 239,
        height: 60,
        decoration: ShapeDecoration(
          color: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: AppTextStyles.buttonTextSmall,
          ),
        ),
      ),
    );
  }
}
