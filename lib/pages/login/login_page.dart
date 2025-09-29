import 'package:flutter/material.dart';
import 'package:ghlapp/providers/login_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    context.read<LoginProvider>().initLocationCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          body: Padding(
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
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                          'assets/images/login.png'.toImageAsset(),
                          SizedBox(height: 60),
                          PrimaryText(
                            text: "Enter Your Phone Number",
                            size: AppDimen.textSize24,
                            weight: AppFont.semiBold,
                          ),
                          SizedBox(height: 10),
                          PrimaryText(
                            text: "",
                            //"Lorem ipsum dolor sit amet consectetur. Elementum imperdiet est",
                            size: AppDimen.textSize16,
                            align: TextAlign.center,
                            weight: AppFont.light,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'Enter your phone number',
                            isShowPrefixIcon: true,
                            controller: value.phoneNumberController,
                            prefixIcon: "assets/images/Vector.png",
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: "Send OTP",
                            onTap: () {
                              if (value.phoneNumberController.text.isEmpty) {
                                AppSnackBar.show(
                                  context,
                                  message: 'Please enter a phone number',
                                );
                              } else if (value
                                      .phoneNumberController
                                      .text
                                      .length !=
                                  10) {
                                AppSnackBar.show(
                                  context,
                                  message: 'Please enter valid phone number',
                                );
                              } else {
                                value.sendOtp(context);
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text: "Login With",
                            size: 16,
                            weight: AppFont.medium,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              socialButton(
                                image: 'assets/images/google.png',
                                onTap: () {
                                  // value.signInWithGoogle(context);
                                },
                              ),
                              SizedBox(width: 10),
                              socialButton(
                                image: 'assets/images/facebook.png',
                                onTap: () {
                                  //  value.signInWithFacebook(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget socialButton({
    required String image,
    required GestureTapCallback onTap,
  }) {
    return Expanded(
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Image.asset(image, scale: 3),
      ).toGesture(onTap: onTap),
    );
  }
}
