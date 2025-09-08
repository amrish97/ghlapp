import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';

class AppTextStyles {
  static TextStyle body = TextStyle(
    color: AppColors.lightGrey,
    fontSize: AppDimen.textSize14,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle bodyStyle = TextStyle(
    color: AppColors.black,
    fontSize: AppDimen.textSize12,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle hintStyle = TextStyle(
    color: AppColors.hintTextStyleColor,
    fontSize: AppDimen.textSize14,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle resendCodeStyle = TextStyle(
    color: AppColors.primary,
    fontSize: AppDimen.textSize16,
    fontFamily: AppFont.font,
    fontWeight: AppFont.semiBold,
  );

  static TextStyle bodyBlackStyle = TextStyle(
    color: AppColors.lightGrey,
    fontSize: AppDimen.textSize16,
    fontFamily: AppFont.font,
    fontWeight: AppFont.regular,
  );

  static TextStyle otpTextStyle = TextStyle(
    color: AppColors.black,
    fontSize: AppDimen.textSize20,
    fontFamily: AppFont.font,
    fontWeight: AppFont.semiBold,
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
    fontWeight: AppFont.semiBold,
  );

  static TextStyle unSelectedTextStyle = TextStyle(
    color: AppColors.black,
    fontSize: AppDimen.textSize12,
    fontWeight: AppFont.semiBold,
    fontFamily: AppFont.font,
  );

  static TextStyle selectedTextStyle = TextStyle(
    color: AppColors.primary,
    fontSize: AppDimen.textSize12,
    fontWeight: AppFont.semiBold,
    fontFamily: AppFont.font,
  );
}
