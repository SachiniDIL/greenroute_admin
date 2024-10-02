import 'package:flutter/material.dart';
import 'package:greenroute_admin/theme.dart';

class InputField extends StatelessWidget {
  const InputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.only(
            top: 13,
            left: 260,
            right: 16,
            bottom: 13,
          ),
          decoration: ShapeDecoration(
            color: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
