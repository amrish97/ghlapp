import 'package:flutter/material.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_dimention.dart';
import 'package:dhlapp/resources/app_font.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign? align;
  const PrimaryText({
    super.key,
    required this.text,
    this.align,
    this.size = AppDimen.textSize16,
    this.weight = AppFont.regular,
    this.color = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: size,
        fontFamily: AppFont.font,
        color: color,
        fontWeight: weight,
        height: 1.5,
      ),
    );
  }
}
