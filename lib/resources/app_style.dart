import 'package:flutter/material.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_dimention.dart';
import 'package:dhlapp/resources/app_font.dart';

class AppTextStyles {
  static TextStyle onBoardStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 32,
    fontFamily: AppFont.font,
    fontWeight: AppFont.semiBold,
  );

  static TextStyle body = TextStyle(
    color: AppColors.lightGrey,
    fontSize: AppDimen.textSize16,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle otpTextStyle = TextStyle(
    color: AppColors.black,
    fontSize: AppDimen.textSize26,
    fontFamily: AppFont.font,
    fontWeight: AppFont.bold,
  );

  static TextStyle errorStyle = TextStyle(
    color: Colors.red,
    fontSize: AppDimen.textSize14,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle errorSnakeBar = TextStyle(
    color: AppColors.white,
    fontSize: AppDimen.textSize14,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle buttonTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: AppDimen.textSize16,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );
}
