import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:dhlapp/resources/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final bool isIconShow;
  final bool showBorderColor;
  final double width;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppColors.primary,
    this.isIconShow = false,
    this.width = double.infinity,
    this.showBorderColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: showBorderColor ? Border.all(color: AppColors.primary) : null,
        ),
        height: 60,
        width: width,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                text: text,
                color: showBorderColor ? AppColors.black : AppColors.white,
                weight: AppFont.semiBold,
                size: 20,
              ),
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
