import 'package:flutter/material.dart';
import '../../theme.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Go back to the previous page
            },
            child: const Icon(
              Icons.arrow_back,
              size: 50,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
