import 'package:dhlapp/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dhlapp/resources/app_style.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isShowPrefixIcon;
  final String? prefixIcon;
  final bool showBorderColor;
  final TextCapitalization textCapitalization;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.showBorderColor = false,
    this.isShowPrefixIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      inputFormatters: [
        if (keyboardType == TextInputType.phone) ...[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
      ],
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppTextStyles.hintStyle,
        filled: true,
        fillColor: AppColors.lightGrey.withAlpha(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              showBorderColor
                  ? BorderSide(
                    color: AppColors.lightGrey.withAlpha(40),
                    width: 1,
                  )
                  : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              showBorderColor
                  ? BorderSide(
                    color: AppColors.lightGrey.withAlpha(40),
                    width: 1,
                  )
                  : BorderSide.none,
        ),
        prefixIcon:
            isShowPrefixIcon ? Image.asset(prefixIcon ?? "", scale: 3) : null,
      ),
      validator: validator,
    );
  }
}
