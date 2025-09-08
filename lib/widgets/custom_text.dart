import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  const PrimaryText({
    super.key,
    required this.text,
    this.align,
    this.maxLines,
    this.size = AppDimen.textSize16,
    this.weight = AppFont.regular,
    this.color = AppColors.black,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
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
