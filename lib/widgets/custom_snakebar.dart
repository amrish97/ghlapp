import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.primary,
    TextStyle? textStyle,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
    double borderRadius = 10,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: PrimaryText(
          text: message,
          color: AppColors.white,
          size: 17,
          align: TextAlign.start,
          weight: AppFont.regular,
        ),
        backgroundColor: backgroundColor,
        behavior: behavior,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        duration: duration,
      ),
    );
  }
}
