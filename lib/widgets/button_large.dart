import 'package:flutter/material.dart';
import 'package:greenroute_admin/theme.dart';

class BtnLarge extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  // Constructor to accept the text and the function to be called on tap
  const BtnLarge({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // This will trigger the provided onPressed function
      child: Column(
        children: [
          SizedBox(
            width: 265,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 265,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color.fromARGB(116, 58, 58, 58),
                          blurRadius: 3,
                          offset: Offset(0,3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 91,
                  top: 12.19,
                  child: SizedBox(
                    width: 82,
                    height: 36.61,
                    child: Text(
                      buttonText, // Use the text passed from the constructor
                      textAlign: TextAlign.center,
                      style: AppTextStyles.buttonTextLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
