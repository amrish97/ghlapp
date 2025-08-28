import 'package:flutter/material.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isIconShow;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isIconShow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text, style: AppTextStyles.buttonTextStyle),
              if (isIconShow) ...[
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, color: AppColors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
