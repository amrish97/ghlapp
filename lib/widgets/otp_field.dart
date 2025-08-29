import 'package:dhlapp/resources/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../resources/app_colors.dart';

class OtpField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  const OtpField({
    super.key,
    required this.focusNode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 4,
      appContext: context,
      focusNode: focusNode,
      controller: controller,
      blinkWhenObscuring: true,
      enableActiveFill: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      cursorColor: Colors.transparent,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 70,
        fieldWidth: 70,
        borderWidth: 0,
        fieldOuterPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: Colors.transparent,
        errorBorderColor: Colors.red,
        activeFillColor: AppColors.lightGrey.withAlpha(25),
        inactiveFillColor: AppColors.lightGrey.withAlpha(25),
        selectedFillColor: AppColors.lightGrey.withAlpha(25),
      ),
      useHapticFeedback: true,
      textStyle: AppTextStyles.otpTextStyle,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
