import 'package:ghlapp/resources/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../resources/app_colors.dart';

class OtpField extends StatelessWidget {
  final bool isFrom;
  final FocusNode focusNode;
  final TextEditingController controller;
  const OtpField({
    super.key,
    required this.focusNode,
    this.isFrom = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final otpLength = isFrom ? 6 : 4;
    final fieldWidth = (size.width - 100) / otpLength;
    return PinCodeTextField(
      length: isFrom ? 6 : 4,
      appContext: context,
      focusNode: focusNode,
      controller: controller,
      enableActiveFill: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(isFrom ? 6 : 4),
      ],
      cursorColor: Colors.transparent,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        borderWidth: 0,
        fieldWidth: fieldWidth.clamp(40, 60),
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: Colors.transparent,
        errorBorderColor: Colors.red,
        activeFillColor: AppColors.lightGrey.withAlpha(25),
        inactiveFillColor: AppColors.lightGrey.withAlpha(25),
        selectedFillColor: AppColors.lightGrey.withAlpha(25),
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      useHapticFeedback: true,
      textStyle: AppTextStyles.otpTextStyle,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
