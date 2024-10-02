import 'package:flutter/material.dart';
import '../../theme.dart';

class SubmitCancelButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback? onCancel; // Add onCancel callback

  const SubmitCancelButtons({
    super.key,
    required this.onSubmit,
    this.onCancel, // Add onCancel as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Cancel Button
        GestureDetector(
          onTap: () {
            if (onCancel != null) {
              onCancel!(); // Only execute onCancel if provided
            } else {
              Navigator.pop(context); // Default action: just pop the screen
            }
          },
          child: Container(
            width: 102,
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFF7F1111),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        // Submit Button
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            width: 102,
            height: 40,
            decoration: ShapeDecoration(
              color: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
