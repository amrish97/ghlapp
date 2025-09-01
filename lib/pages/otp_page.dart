import 'package:dhlapp/providers/login_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/resources/app_style.dart';
import 'package:dhlapp/widgets/custom_button.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:dhlapp/widgets/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final bool isFromVerification;
  final String aadhaarNumber;
  final int referenceID;

  const OtpPage({
    super.key,
    this.isFromVerification = false,
    this.aadhaarNumber = "",
    this.referenceID = 0,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().checkAndLoadSms(context);
      context.read<LoginProvider>().startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Consumer<LoginProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          PrimaryText(
                            text: "Enter Your OTP",
                            size: 25,
                            color: AppColors.black,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text:
                                "Lorem ipsum dolor sit amet consectetur. Elementum imperdiet est",
                            size: 15,
                            align: TextAlign.center,
                            weight: AppFont.regular,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          OtpField(
                            isFrom: widget.isFromVerification,
                            focusNode: FocusNode(),
                            controller:
                                widget.isFromVerification
                                    ? value.aadhaarVerifyOTPController
                                    : value.otpController,
                          ),
                          SizedBox(height: 10),
                          resendOTP(
                            onTap: () {
                              if (widget.isFromVerification) {
                                value.resendAadhaarOTP(
                                  context,
                                  value.aadhaarController.text,
                                );
                                value.startTimer();
                              } else {
                                value.resendOtp(
                                  context,
                                  value.phoneNumberController.text,
                                );
                                value.startTimer();
                              }
                            },
                            canResend: value.canResend,
                            seconds: value.seconds,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: "Verify",
                            onTap: () {
                              if (widget.isFromVerification) {
                                value.verifyAadhaarOTP(
                                  context,
                                  value.aadhaarVerifyOTPController.text,
                                  widget.referenceID,
                                  widget.aadhaarNumber,
                                );
                              } else {
                                value.verifyOtp(
                                  value.phoneNumberController.text,
                                  value.otpController.text,
                                  context,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget resendOTP({
    required GestureTapCallback onTap,
    bool canResend = false,
    int seconds = 30,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        canResend
            ? TextButton(
              onPressed: onTap,
              child: Text("Resend OTP", style: AppTextStyles.body),
            )
            : RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Resend code in ",
                    style: AppTextStyles.bodyBlackStyle,
                  ),
                  TextSpan(
                    text: seconds.toString(),
                    style: AppTextStyles.resendCodeStyle,
                  ),
                  TextSpan(text: " sec", style: AppTextStyles.bodyBlackStyle),
                ],
              ),
            ),
      ],
    );
  }
}
