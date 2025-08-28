import 'package:dhlapp/app/app_routes.dart';
import 'package:dhlapp/providers/login_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_button.dart';
import 'package:dhlapp/widgets/custom_snakebar.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:dhlapp/widgets/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().checkAndLoadSms(context);
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
                            size: 30,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text:
                                "Lorem ipsum dolor sit amet consectetur. Elementum imperdiet est",
                            size: 16,
                            align: TextAlign.center,
                            weight: AppFont.light,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 40,
                            ),
                            child: OtpField(focusNode: FocusNode()),
                          ),
                          resendCode(),
                          SizedBox(height: 20),
                          CustomButton(
                            text: "Verify",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouteEnum.bottomPage.name,
                              );
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

  Widget resendCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrimaryText(
          text: "Resend Code in",
          color: AppColors.hintTextColor,
          weight: AppFont.regular,
          size: 16,
        ),
        PrimaryText(
          text: " 20 ",
          color: Colors.red,
          weight: AppFont.regular,
          size: 16,
        ),
        PrimaryText(
          text: "Sec",
          color: AppColors.hintTextColor,
          weight: AppFont.regular,
          size: 16,
        ),
      ],
    );
  }
}
