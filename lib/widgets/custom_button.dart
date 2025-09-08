import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final bool isIconShow;
  final bool showBorderColor;
  final double width;
  final bool isLoader;
  final Widget iconWidget;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppColors.primary,
    this.isIconShow = false,
    this.width = double.infinity,
    this.showBorderColor = false,
    this.iconWidget = const SizedBox(),
    this.isLoader = false,
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
        height: 50,
        width: width,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoader) ...[
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 3,
                    backgroundColor: AppColors.greenCircleColor,
                  ),
                ),
              ],
              iconWidget,
              SizedBox(width: 10),
              if (!isLoader)
                PrimaryText(
                  text: text,
                  color: showBorderColor ? AppColors.black : AppColors.white,
                  weight: AppFont.semiBold,
                  size: 15,
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
