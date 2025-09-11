import 'package:ghlapp/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool isShowPrefixIcon;
  final String? prefixIcon;
  final bool showBorderColor;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final String? errorText;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.showBorderColor = false,
    this.isShowPrefixIcon = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTextStyles.hintStyle,
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
        errorText: errorText?.isNotEmpty == true ? errorText : null,
        errorStyle: AppTextStyles.errorStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.lightGrey.withAlpha(40),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.lightGrey.withAlpha(80),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        filled: true,
        fillColor: AppColors.lightGrey.withAlpha(20),
        prefixIcon:
            isShowPrefixIcon ? Image.asset(prefixIcon ?? "", scale: 3) : null,
      ),
      onChanged: onChanged,
    );
  }
}
